import Foundation

/// Lazily fetches `/api/v1/sdk/config` and caches the in-flight `Task` so concurrent callers
/// share a single network request.
///
/// On the first call the actor starts the fetch and stores the `Task`. Any subsequent caller
/// awaits the same `Task` — so we never hit the endpoint twice and there is no race between
/// callers seeing different `SdkConfig` values.
///
/// The actor never throws: on any failure (network, decode, non-200) it resolves with
/// `SdkConfig.default(for:)` for the merchant-selected environment. The failed task stays
/// cached for the lifetime of the SDK session, so once we have fallen back to defaults we
/// keep using them.
///
///
/// TODO(retry): retry/backoff is intentionally not implemented yet. To decide before adding:
///   - per-attempt timeout (doc says "~1s ?", marked TBD in the Phase 2 spec)
///   - retry count and backoff strategy (fixed? exponential? jittered?)
///   - which failures should be retried (transport errors? 5xx? never 4xx?)
///   - whether a retry should clear the cached task so a *new* caller triggers re-fetch,
///     or whether retries should be bounded inside the first call only (current design
///     caches the failed Task, so today's behavior is "no retry ever")
final actor SdkConfigService {

    private let session: URLSession
    private let decoder: JSONDecoder

    private var fetchTask: Task<SdkConfig, Never>?

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    /// Returns the SDK configuration, triggering the fetch on first call and re-using the
    /// in-flight `Task` for any concurrent callers.
    func config() async -> SdkConfig {
        if let existing = fetchTask {
            return await existing.value
        }
        let task = Task { await self.fetch() }
        fetchTask = task
        return await task.value
    }

    /// Convenience: returns region-resolved endpoints for the given currency.
    func endpoints(for currency: Currency) async -> SdkConfig.Endpoints {
        await config().endpoints(for: currency)
    }

    private func fetch() async -> SdkConfig {
        var request = URLRequest(url: SdkConfig.Endpoints.sdkConfigURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SdkVersionHeader.value, forHTTPHeaderField: SdkVersionHeader.key)

        do {
            let (data, response) = try await perform(request)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return .default
            }
            return try decoder.decode(SdkConfig.self, from: data)
        } catch {
            return .default
        }
    }


    /// `URLSession.data(for:)` is iOS 15+. Wrap the callback API to back-deploy to iOS 13.
    private func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let data = data, let response = response else {
                    continuation.resume(throwing: NetworkError.noResponse)
                    return
                }
                continuation.resume(returning: (data, response))
            }.resume()
        }
    }
}

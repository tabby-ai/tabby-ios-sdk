import SwiftUI

// MARK: - AsyncImage

struct AsyncImage<Placeholder: View>: View {

    // MARK: - Private Properties

    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let result: (UIImage) -> Image

    // MARK: - Life Cycle

    init(
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder result: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.result = result
        _loader = ObservedObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }

    // MARK: - Body

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    // MARK: - Body Properties

    private var content: some View {
        Group {
            if let image = loader.image {
                result(image)
            } else {
                placeholder
            }
        }
    }
}

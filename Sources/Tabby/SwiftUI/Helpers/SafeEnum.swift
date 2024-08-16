import Foundation

/// A property wrapper that safely decodes enums.
@propertyWrapper
public struct SafeEnum<Value: RawRepresentable & Equatable> {

    public var wrappedValue: Value? {
        get { rawValue.flatMap { Value(rawValue: $0) } }
        set { rawValue = newValue?.rawValue }
    }

    public var projectedValue: Value.RawValue? {
        get { rawValue }
        set { rawValue = newValue }
    }

    public var rawValue: Value.RawValue?

    public init(wrappedValue: Value? = nil) {
        self.rawValue = wrappedValue?.rawValue
    }

    public init(rawValue: Value.RawValue) {
        self.rawValue = rawValue
    }
}

extension SafeEnum: Equatable where Value.RawValue: Equatable {
}

extension SafeEnum: Hashable where Value.RawValue: Hashable, Value: Hashable {
}

extension SafeEnum: Decodable where Value.RawValue: Decodable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Value.RawValue.self)
        self.init(rawValue: rawValue)
    }
}

extension SafeEnum: Encodable where Value.RawValue: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension KeyedDecodingContainer {
    
    public func decode<Value: RawRepresentable & Equatable>(
        _ type: SafeEnum<Value>.Type,
        forKey key: Key
    ) throws -> SafeEnum<Value> where Value.RawValue: Decodable {
        try decodeIfPresent(type, forKey: key) ?? SafeEnum()
    }
}

extension KeyedEncodingContainer {
    
    public mutating func encode<Value: RawRepresentable & Equatable>(
        _ value: SafeEnum<Value>,
        forKey key: Key
    ) throws where Value.RawValue: Encodable {
        try encodeIfPresent(value.rawValue.map { _ in value }, forKey: key)
    }
}

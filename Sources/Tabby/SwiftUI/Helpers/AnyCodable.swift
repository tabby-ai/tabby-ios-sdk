import Foundation

struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode([String: AnyCodable].self) {
                self.value = value.mapValues({ $0.value })
            } else if let value = try? container.decode([AnyCodable].self) {
                self.value = value.compactMap({ $0.value })
            } else if let value = try? container.decode(Bool.self) {
                self.value = value
            } else if let value = try? container.decode(String.self) {
                self.value = value
            } else if let value = try? container.decode(Int.self) {
                self.value = value
            } else if let value = try? container.decode(Int8.self) {
                self.value = value
            } else if let value = try? container.decode(Int16.self) {
                self.value = value
            } else if let value = try? container.decode(Int32.self) {
                self.value = value
            } else if let value = try? container.decode(Int64.self) {
                self.value = value
            } else if let value = try? container.decode(UInt.self) {
                self.value = value
            } else if let value = try? container.decode(UInt8.self) {
                self.value = value
            } else if let value = try? container.decode(UInt16.self) {
                self.value = value
            } else if let value = try? container.decode(UInt32.self) {
                self.value = value
            } else if let value = try? container.decode(UInt64.self) {
                self.value = value
            } else if let value = try? container.decode(Double.self) {
                self.value = value
            } else if let value = try? container.decode(Float.self) {
                self.value = value
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
            }
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch value {
            case let value as [String: AnyCodable]:
                try container.encode(value)
            case let value as [String: Any]:
                try container.encode(value.mapValues(AnyCodable.init))
            case let value as [AnyCodable]:
                try container.encode(value)
            case let value as [Any]:
                try container.encode(value.map(AnyCodable.init))
            case let value as Bool:
                try container.encode(value)
            case let value as String:
                try container.encode(value)
            case let value as Int:
                try container.encode(value)
            case let value as Int8:
                try container.encode(value)
            case let value as Int16:
                try container.encode(value)
            case let value as Int32:
                try container.encode(value)
            case let value as Int64:
                try container.encode(value)
            case let value as UInt:
                try container.encode(value)
            case let value as UInt8:
                try container.encode(value)
            case let value as UInt16:
                try container.encode(value)
            case let value as UInt32:
                try container.encode(value)
            case let value as UInt64:
                try container.encode(value)
            case let value as Double:
                try container.encode(value)
            case let value as Float:
                try container.encode(value)
            default:
                throw EncodingError.invalidValue(value, .init(codingPath: [], debugDescription: "Unsupported type"))
            }
        }
}

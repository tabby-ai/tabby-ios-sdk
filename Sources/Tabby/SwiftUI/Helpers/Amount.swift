import Foundation

/// Represents a decimal amount. Can be decoded from a string.
public struct Amount: Codable, Equatable {

    public var value: Decimal {
        didSet {
            if oldValue != value {
                decodedString = nil
            }
        }
    }
    private var decodedString: String?

    public init(_ value: Decimal) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let decimal = try container.decode(Decimal.self)
            self.init(decimal)
        } catch {
            if let double = try? container.decode(Double.self) {
                self.init(Decimal(double))
                return
            }
            guard let string = try? container.decode(String.self) else {
                throw error
            }
            guard let value = Decimal(string: string) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid decimal string: \(string)"
                    )
                )
            }
            self.init(value)
            decodedString = string
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

extension Amount: Comparable {

    public static func < (lhs: Amount, rhs: Amount) -> Bool {
        lhs.value < rhs.value
    }
}

extension Amount: ExpressibleByFloatLiteral {

    public init(floatLiteral value: Double) {
        self.init(Decimal(floatLiteral: value))
    }
}

extension Amount: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = Decimal.IntegerLiteralType

    public init(integerLiteral value: Int) {
        self.init(Decimal(integerLiteral: value))
    }
}

extension Amount: CustomStringConvertible {

    public var description: String {
        decodedString ?? value.description
    }
}

extension Amount: LosslessStringConvertible {

    public init?(_ description: String) {
        guard let value = Decimal(string: description) else {
            return nil
        }
        self.init(value)
        decodedString = description
    }
}

extension Amount: Numeric {

    public typealias Magnitude = Amount

    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let value = Decimal(exactly: source) else {
            return nil
        }
        self.init(value)
    }

    public var magnitude: Amount {
        Amount(value.magnitude)
    }
    
    public static func - (lhs: Amount, rhs: Amount) -> Amount {
        Amount(lhs.value - rhs.value)
    }

    public static func * (lhs: Amount, rhs: Amount) -> Amount {
        Amount(lhs.value * rhs.value)
    }
    
    public static func + (lhs: Amount, rhs: Amount) -> Amount {
        Amount(lhs.value + rhs.value)
    }

    public static func *= (lhs: inout Amount, rhs: Amount) {
        lhs.value *= rhs.value
    }
}

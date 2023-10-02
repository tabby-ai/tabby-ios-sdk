//
//  Payment.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

public struct Buyer: Codable {
  public let email: String
  public let phone: String
  public let name: String
  public let dob: String?
  
  public init(
    email: String,
    phone: String,
    name: String,
    dob: String? = nil
  ) {
    self.email = email
    self.phone = phone
    self.name = name
    self.dob = dob
  }
}

public struct OrderItem: Codable {
  public let description: String? // 'To be displayed in tabby order information'
  public let product_url: String? // https://tabby.store/p/SKU123
  public let quantity: Int // 1
  public let reference_id: String // 'SKU123'
  public let title: String // 'Sample Item #1'
  public let unit_price: String // '300'
  public let category: String // jeans / dress / shorts
  
  public init(
    description: String? = nil,
    product_url: String? = nil,
    quantity: Int,
    reference_id: String,
    title: String,
    unit_price: String,
    category: String
  ) {
    self.description = description
    self.product_url = product_url
    self.quantity = quantity
    self.reference_id = reference_id
    self.title = title
    self.unit_price = unit_price
    self.category = category
  }
}

public struct Order: Codable {
  public let reference_id: String // #xxxx-xxxxxx-xxxx
  public let items: [OrderItem]
  public let shipping_amount: String? // '50'
  public let tax_amount: String? // '500'
  public let discount_amount: String? // '500'
  
  public init(
    reference_id: String,
    items: [OrderItem],
    shipping_amount: String? = nil,
    tax_amount: String? = nil,
    discount_amount: String? = nil
  ) {
    self.reference_id = reference_id
    self.items = items
    self.shipping_amount = shipping_amount
    self.tax_amount = tax_amount
    self.discount_amount = discount_amount
  }
}

public enum OrderItemPaymentMethod: String, Codable {
  case card = "card"
  case cod = "cod"
}

public enum OrderItemStatus: String, Codable {
  case new = "new"
  case processing = "processing"
  case complete = "complete"
  case refunded = "refunded"
  case canceled = "canceled"
  case unknown = "unknown"
  
}

public struct OrderHistory: Codable {
  public let purchased_at: String // "2019-08-24T14:15:22Z"
  public let amount: String // "10.00"
  public let payment_method: OrderItemPaymentMethod?
  public let status: OrderItemStatus
  public let buyer: Buyer?
  public let items: [OrderItem]?
  public let shipping_address: ShippingAddress?
  
  public init(
    purchased_at: String,
    amount: String,
    payment_method: OrderItemPaymentMethod? = nil,
    status: OrderItemStatus,
    buyer: Buyer? = nil,
    items: [OrderItem]? = nil,
    shipping_address: ShippingAddress?
  ) {
    self.purchased_at = purchased_at
    self.amount = amount
    self.payment_method = payment_method
    self.status = status
    self.buyer = buyer
    self.items = items
    self.shipping_address = shipping_address
  }
}

public struct ShippingAddress: Codable {
  public let address: String
  public let city: String
  public let zip: String
  
  public init(address: String, city: String, zip: String) {
    self.address = address
    self.city = city
    self.zip = zip
  }
}

public struct BuyerHistory: Codable {
  public let registered_since: String // "2019-08-24T14:15:22Z"
  public let loyalty_level: Int // 0
  public let wishlist_count: Int? // 0
  public let is_social_networks_connected: Bool? // true
  public let is_phone_number_verified: Bool? // true
  public let is_email_verified: Bool? // true
  
  public init(
    registered_since: String,
    loyalty_level: Int,
    wishlist_count: Int? = nil,
    is_social_networks_connected: Bool? = nil,
    is_phone_number_verified: Bool? = nil,
    is_email_verified: Bool? = nil
  ) {
    self.registered_since = registered_since
    self.loyalty_level = loyalty_level
    self.wishlist_count = wishlist_count
    self.is_social_networks_connected = is_social_networks_connected
    self.is_phone_number_verified = is_phone_number_verified
    self.is_email_verified = is_email_verified
  }
}

public struct Payment: Codable {
    
    /// Total payment amount, including tax, shipping and any discounts. Allows to send up to 2 decimals for AED, SAR, QAR; up to 3 decimals for KWD and BHD.
    public let amount: String
    public let currency: Currency
    public let description: String?
    public let buyer: Buyer
    public let buyer_history: BuyerHistory
    public let order: Order
    public let order_history: [OrderHistory]
    public let meta: [String: Any]?
    public let shipping_address: ShippingAddress
    
    /// Initialize Payment with Codable meta type
    /// - Parameters:
    ///   - amount: Total payment amount, including tax, shipping and any discounts. Allows to send up to 2 decimals for AED, SAR, QAR; up to 3 decimals for KWD and BHD.
    ///   - meta: Key-value pair of any data that you want to attach to the payment. Can be used to store order ID, customer ID, etc.
    /// - Example:
    /// ```
    /// Payment(amount: "10.00", ..., meta: ["orderId": "123456"])
    /// ```
    public init(
        amount: String,
        currency: Currency,
        description: String? = nil,
        buyer: Buyer,
        buyer_history: BuyerHistory,
        order: Order,
        order_history: [OrderHistory],
        meta: [String: Any]? = nil,
        shipping_address: ShippingAddress
    ) {
        self.amount = amount
        self.currency = currency
        self.description = description
        self.buyer = buyer
        self.buyer_history = buyer_history
        self.order = order
        self.order_history = order_history
        self.meta = meta
        self.shipping_address = shipping_address
    }
    
    /// Initialize Payment with Codable meta type
    /// Example:
    /// ```
    /// struct Meta: Codable {
    ///    let orderId: String
    ///    let customer: String
    /// }
    public init<MetaType: Codable>(
        amount: String,
        currency: Currency,
        description: String? = nil,
        buyer: Buyer,
        buyer_history: BuyerHistory,
        order: Order,
        order_history: [OrderHistory],
        meta: MetaType,
        shipping_address: ShippingAddress
    ) throws {
        self.amount = amount
        self.currency = currency
        self.description = description
        self.buyer = buyer
        self.buyer_history = buyer_history
        self.order = order
        self.order_history = order_history
        self.meta = try meta.toDictionary()
        self.shipping_address = shipping_address
    }
    
    public enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case description
        case buyer
        case buyer_history
        case order
        case order_history
        case meta
        case shipping_address
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try container.decode(String.self, forKey: .amount)
        currency = try container.decode(Currency.self, forKey: .currency)
        description = try container.decode(String.self, forKey: .description)
        buyer = try container.decode(Buyer.self, forKey: .buyer)
        buyer_history = try container.decode(BuyerHistory.self, forKey: .buyer_history)
        order = try container.decode(Order.self, forKey: .order)
        order_history = try container.decode([OrderHistory].self, forKey: .order_history)
        meta = try container.decode(AnyCodable.self, forKey: .meta).value as? [String: Any]
        shipping_address = try container.decode(ShippingAddress.self, forKey: .shipping_address)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(currency, forKey: .currency)
        try container.encode(description, forKey: .description)
        try container.encode(buyer, forKey: .buyer)
        try container.encode(buyer_history, forKey: .buyer_history)
        try container.encode(order, forKey: .order)
        try container.encode(order_history, forKey: .order_history)
        
        
        if let meta = meta {
            try container.encode(AnyCodable(meta), forKey: .meta)
        }
        
        try container.encode(shipping_address, forKey: .shipping_address)
    }
}

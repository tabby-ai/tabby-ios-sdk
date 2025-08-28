//
//  Payment.swift
//  Tabby
//
//  Created by ilya.kuznetsov on 26.08.2021.
//

import Foundation

public struct Buyer: Encodable {
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

public struct OrderItem: Encodable {
    public let description: String?  // 'To be displayed in tabby order information'
    public let product_url: String?  // https://tabby.store/p/SKU123
    public let quantity: Int  // 1
    public let reference_id: String  // 'SKU123'
    public let title: String  // 'Sample Item #1'
    public let unit_price: String  // '300'
    public let category: String  // jeans / dress / shorts

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

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(
            String.self,
            forKey: .description
        )
        self.product_url = try container.decodeIfPresent(
            String.self,
            forKey: .product_url
        )
        self.quantity = try container.decode(Int.self, forKey: .quantity)
        self.reference_id = try container.decode(
            String.self,
            forKey: .reference_id
        )
        self.title = try container.decode(String.self, forKey: .title)
        self.unit_price = try container.decode(Amount.self, forKey: .unit_price)
            .description
        self.category = try container.decode(String.self, forKey: .category)
    }
}

public struct Order: Encodable {
    public let reference_id: String  // #xxxx-xxxxxx-xxxx
    public let items: [OrderItem]
    public let shipping_amount: String?  // '50'
    public let tax_amount: String?  // '500'
    public let discount_amount: String?  // '500'

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

public enum OrderItemPaymentMethod: String, Encodable {
    case card = "card"
    case cod = "cod"
}

public enum OrderItemStatus: String, Encodable {
    case new = "new"
    case processing = "processing"
    case complete = "complete"
    case refunded = "refunded"
    case canceled = "canceled"
    case unknown = "unknown"
}

public struct OrderHistory: Encodable {
    public let purchased_at: String  // "2019-08-24T14:15:22Z"
    public let amount: String  // "10.00"
    @SafeEnum public var payment_method: OrderItemPaymentMethod?
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

public struct ShippingAddress: Encodable {
    public let address: String
    public let city: String
    public let zip: String

    public init(address: String, city: String, zip: String) {
        self.address = address
        self.city = city
        self.zip = zip
    }
}

public struct BuyerHistory: Encodable {
    public let registered_since: String  // "2019-08-24T14:15:22Z"
    public let loyalty_level: Int  // 0
    public let wishlist_count: Int?  // 0
    public let is_social_networks_connected: Bool?  // true
    public let is_phone_number_verified: Bool?  // true
    public let is_email_verified: Bool?  // true

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

public struct Payment: Encodable {

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
    public let attachment: Attachment?

    /// Initialize Payment with Encodable meta type
    /// - Parameters:
    ///   - amount: Total payment amount, including tax, shipping and any discounts. Allows to send up to 2 decimals for AED, SAR, QAR; up to 3 decimals for KWD and BHD.
    ///   - currency: The currency of the payment.
    ///   - description: An optional description of the payment.
    ///   - buyer: The buyer information.
    ///   - buyer_history: The history of the buyer.
    ///   - order: The order details.
    ///   - order_history: The history of the order. It is highly recommended to send a non-empty order history when creating a session.
    ///   - meta: Key-value pair of any data that you want to attach to the payment. Can be used to store order ID, customer ID, etc.
    ///   - shipping_address: The shipping address for the payment.
    ///   - attachment: Extra data (booking info, insurance, flight reservations, ...)
    ///
    /// - Example:
    /// ```
    /// Payment(
    ///     amount: "10.00",
    ///     currency: .aed,
    ///     description: "Order payment",
    ///     buyer: buyer,
    ///     buyer_history: buyerHistory,
    ///     order: order,
    ///     order_history: orderHistory,
    ///     meta: ["orderId": "123456"],
    ///     shipping_address: shippingAddress,
    ///     attachment: attachment
    /// )
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
        shipping_address: ShippingAddress,
        attachment: Attachment? = nil
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
        self.attachment = attachment
    }

    /// Initialize Payment with Encodable meta type
    /// Example:
    /// ```
    /// struct Meta: Encodable {
    ///    let orderId: String
    ///    let customer: String
    /// }
    public init<MetaType: Encodable>(
        amount: String,
        currency: Currency,
        description: String? = nil,
        buyer: Buyer,
        buyer_history: BuyerHistory,
        order: Order,
        order_history: [OrderHistory],
        meta: MetaType,
        shipping_address: ShippingAddress,
        attachment: Attachment? = nil
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
        self.attachment = attachment
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

public struct Insurance: Encodable {
    public let insurance_company: String?
    public let insurance_type: String?
    public let insurance_price: String?

    public init(
        insurance_company: String?,
        insurance_type: String?,
        insurance_price: String?) {
        self.insurance_company = insurance_company
        self.insurance_type = insurance_type
        self.insurance_price = insurance_price
    }
}

public enum Gender: String, Encodable {
    case male = "M"
    case female = "F"
    case other = "O"
}

public struct Passenger: Encodable {
    public let full_name: String?
    public let first_name: String?
    public let last_name: String?
    public let dob: String?  // ISO 8601 date of birth, e.g. 2018-10-17
    public let document_type: String?
    public let document_id: String?
    public let expiration_id_date: String?  // ISO 8601 date e.g. 2018-10-17
    public let nationality: String?
    public let gender: Gender?

    public init(
        full_name: String?,
        first_name: String?,
        last_name: String?,
        dob: String?,
        document_type: String?,
        document_id: String?,
        expiration_id_date: String?,
        nationality: String?,
        gender: Gender?
    ) {
        self.full_name = full_name
        self.first_name = first_name
        self.last_name = last_name
        self.dob = dob
        self.document_type = document_type
        self.document_id = document_id
        self.expiration_id_date = expiration_id_date
        self.nationality = nationality
        self.gender = gender
    }
}

public struct Attachment: Encodable {
    public let body: AttachmentBody
    public let content_type: String // Version of used schema
    
    public init(
        body: AttachmentBody,
        content_type: String = "application/vnd.tabby.v1+json"
    ) {
        self.body = body
        self.content_type = content_type
    }
}

public struct InsuranceDetails: Encodable {

    public struct PolicyDetails: Encodable {

        public struct CarDetails: Encodable {
            public let manufacturer: String
            public let model: String
            public let year: String
            
            public init(
                manufacturer: String,
                model: String,
                year: String
            ) {
                self.manufacturer = manufacturer
                self.model = model
                self.year = year
            }
        }

        public struct TravelDetails: Encodable {
            public let departure_country: String
            public let arrival_country: String
            
            public init(
                departure_country: String,
                arrival_country: String
            ) {
                self.departure_country = departure_country
                self.arrival_country = arrival_country
            }
        }

        public let insurance_type: String  // Insurance policy type
        public let insurance_start_dt: String  // ISO 8601 start date, e.g. 2018-10-17
        public let insurance_end_dt: String  // ISO 8601 start date, e.g. 2018-10-17
        public let insured_amount: String  // Amount of insurance policy
        public let car_details: CarDetails? // Required for car insurance
        public let travel_details: TravelDetails? // Required for travel insurance
        public let refundable: Bool?  // If insurance can be cancelled/refunded - true, otherwise - false
        public let provider_name: String?
        
        public init(
            insurance_type: String,
            insurance_start_dt: String,
            insurance_end_dt: String,
            insured_amount: String,
            car_details: CarDetails?,
            travel_details: TravelDetails?,
            refundable: Bool?,
            provider_name: String?
        ) {
            self.insurance_type = insurance_type
            self.insurance_start_dt = insurance_start_dt
            self.insurance_end_dt = insurance_end_dt
            self.insured_amount = insured_amount
            self.car_details = car_details
            self.travel_details = travel_details
            self.refundable = refundable
            self.provider_name = provider_name
        }
    }

    public struct Client: Encodable {
        public let full_name: String?
        public let first_name: String
        public let last_name: String
        public let dob: String?  // ISO 8601 date of birth, e.g. 2018-10-17
        public let document_type: String
        public let document_id: String?
        public let expiration_id_dt: String  // ISO 8601 date e.g. 2018-10-17
        public let nationality: String?
        public let gender: Gender?
        
        public init(
            full_name: String?,
            first_name: String,
            last_name: String,
            dob: String?,
            document_type: String,
            document_id: String?,
            expiration_id_dt: String,
            nationality: String?,
            gender: Gender?
        ) {
            self.full_name = full_name
            self.first_name = first_name
            self.last_name = last_name
            self.dob = dob
            self.document_type = document_type
            self.document_id = document_id
            self.expiration_id_dt = expiration_id_dt
            self.nationality = nationality
            self.gender = gender
        }
    }

    public struct PaymentHistorySimple: Encodable {
        public let unique_account_identifier: String?  // Unique name / number to identify the specific customer account
        public let paid_before_flag: String?  // Whether the customer has paid before or not
        public let date_of_last_paid_purchase: String  // ISO 8601 date e.g. 2018-10-17
        public let date_of_first_paid_purchase: String  // ISO 8601 date e.g. 2018-10-17
        
        public init(
            unique_account_identifier: String?,
            paid_before_flag: String?,
            date_of_last_paid_purchase: String,
            date_of_first_paid_purchase: String
        ) {
            self.unique_account_identifier = unique_account_identifier
            self.paid_before_flag = paid_before_flag
            self.date_of_last_paid_purchase = date_of_last_paid_purchase
            self.date_of_first_paid_purchase = date_of_first_paid_purchase
        }
    }

    public let policy_details: PolicyDetails  // Information about insurance
    public let client: Client
    public let payment_history_simple: PaymentHistorySimple?
    
    public init(
        policy_details: PolicyDetails,
        client: Client,
        payment_history_simple: PaymentHistorySimple?
    ) {
        self.policy_details = policy_details
        self.client = client
        self.payment_history_simple = payment_history_simple
    }
}

public struct HotelReservationDetails: Encodable {

    public struct HotelItinerary: Encodable {
        public let hotel_name: String?
        public let address: String?
        public let hotel_city: String?
        public let hotel_country: String?
        public let start_date: String?  // ISO 8601 date e.g. 2018-10-17
        public let end_date: String?  // ISO 8601 date e.g. 2018-10-17
        public let number_of_rooms: Int?
        public let `class`: String?
        
        public init(
            hotel_name: String?,
            address: String?,
            hotel_city: String?,
            hotel_country: String?,
            start_date: String?,
            end_date: String?,
            number_of_rooms: Int?,
            `class`: String?
        ) {
            self.hotel_name = hotel_name
            self.address = address
            self.hotel_city = hotel_city
            self.hotel_country = hotel_country
            self.start_date = start_date
            self.end_date = end_date
            self.number_of_rooms = number_of_rooms
            self.`class` = `class`
        }
    }

    public let pnr: String?  // Trip booking number, e.g. TR9088999
    public let hotel_itinerary: [HotelItinerary] // Hotel itinerary data, one per segment
    public let insurance: [Insurance] // Insurance data
    public let passengers: [Passenger] // Passengers data
    public let affiliate_name: String? // Name of the affiliate that originated the purchase. If none, leave blank.
    
    public init(
        pnr: String?,
        hotel_itinerary: [HotelItinerary],
        insurance: [Insurance],
        passengers: [Passenger],
        affiliate_name: String?
    ) {
        self.pnr = pnr
        self.hotel_itinerary = hotel_itinerary
        self.insurance = insurance
        self.passengers = passengers
        self.affiliate_name = affiliate_name
    }
}

public struct FlightReservationDetails: Encodable {

    public struct Itinerary: Encodable {
        public let departure_city: String?
        public let departure_country: String?
        public let arrival_city: String?
        public let arrival_country: String?
        public let carrier: String?
        public let departure_date: String?  // RFC3339 e.g. 2018-10-17T07:26:33Z
        public let `class`: String?
        public let refundable: Bool?  // true - if ticket can be cancelled/refundeds
        
        public init(
            departure_city: String?,
            departure_country: String?,
            arrival_city: String?,
            arrival_country: String?,
            carrier: String?,
            departure_date: String?,
            `class`: String?,
            refundable: Bool?
        ) {
            self.departure_city = departure_city
            self.departure_country = departure_country
            self.arrival_city = arrival_city
            self.arrival_country = arrival_country
            self.carrier = carrier
            self.departure_date = departure_date
            self.`class` = `class`
            self.refundable = refundable
        }
    }

    public let pnr: String? // Trip booking number, e.g. TR9088999
    public let itinerary: [Itinerary] // Itinerary data, one per segment
    public let insurance: [Insurance] // Insurance data
    public let passengers: [Passenger] // Passengers data
    public let affiliate_name: String? // Name of the affiliate that originated the purchase. If none, leave blank.
    
    public init(
        pnr: String?,
        itinerary: [Itinerary],
        insurance: [Insurance],
        passengers: [Passenger],
        affiliate_name: String?
    ) {
        self.pnr = pnr
        self.itinerary = itinerary
        self.insurance = insurance
        self.passengers = passengers
        self.affiliate_name = affiliate_name
    }
}

public struct AttachmentBody: Encodable {

    public struct PaymentHistoryFull: Encodable {

        public enum PaymentOption: String, Encodable {
            case card
            case directBanking = "direct banking"
            case cod
            case other
        }

        public let unique_account_identifier: String?  // Unique name / number to identify the specific customer account
        public let payment_option: PaymentOption?  // One of - card / direct banking / COD (cash) / other
        public let number_paid_purchases: Int?
        public let total_amount_paid_purchases: Int?
        public let date_of_last_paid_purchase: String?  // ISO 8601 date e.g. 2018-10-17
        public let date_of_first_paid_purchase: String?  // ISO 8601 date e.g. 2018-10-17
        public let count_paid_purchases_last_month: Int?
        public let amount_paid_purchases_last_month: Int?
        public let max_paid_amount_for_1purchase: Int?
        
        public init(
            unique_account_identifier: String?,
            payment_option: PaymentOption?,
            number_paid_purchases: Int?,
            total_amount_paid_purchases: Int?,
            date_of_last_paid_purchase: String?,
            date_of_first_paid_purchase: String?,
            count_paid_purchases_last_month: Int?,
            amount_paid_purchases_last_month: Int?,
            max_paid_amount_for_1purchase: Int?
        ) {
            self.unique_account_identifier = unique_account_identifier
            self.payment_option = payment_option
            self.number_paid_purchases = number_paid_purchases
            self.total_amount_paid_purchases = total_amount_paid_purchases
            self.date_of_last_paid_purchase = date_of_last_paid_purchase
            self.date_of_first_paid_purchase = date_of_first_paid_purchase
            self.count_paid_purchases_last_month = count_paid_purchases_last_month
            self.amount_paid_purchases_last_month = amount_paid_purchases_last_month
            self.max_paid_amount_for_1purchase = max_paid_amount_for_1purchase
        }
    }

    public struct PaymentHistorySimple: Encodable {
        public let unique_account_identifier: String?  // Unique name / number to identify the specific customer account
        public let paid_before_flag: Bool?  // Whether the customer has paid before or not
        public let date_of_last_paid_purchase: String?  // ISO 8601 date e.g. 2018-10-17
        public let date_of_first_paid_purchase: String?  // ISO 8601 date e.g. 2018-10-17
        
        public init(
            unique_account_identifier: String?,
            paid_before_flag: Bool?,
            date_of_last_paid_purchase: String?,
            date_of_first_paid_purchase: String?
        ) {
            self.unique_account_identifier = unique_account_identifier
            self.paid_before_flag = paid_before_flag
            self.date_of_last_paid_purchase = date_of_last_paid_purchase
            self.date_of_first_paid_purchase = date_of_first_paid_purchase
        }
    }

    public struct FlightPointsSimple: Encodable {

        public struct Origin: Encodable {
            public let air_code: String  // Origin IATA airport code, for example - JFK
            public let city_code: String  // Origin city code, for example - NYC
            
            public init(
                air_code: String,
                city_code: String
            ) {
                self.air_code = air_code
                self.city_code = city_code
            }
        }

        public struct Destination: Encodable {
            public let air_code: String  // Destination IATA airport code, for example - LAX
            public let city_code: String  // Destination city code, for example - LAX
            
            public init(
                air_code: String,
                city_code: String
            ) {
                self.air_code = air_code
                self.city_code = city_code
            }
        }
        public let origin: Origin?  // Origin city and airport
        public let destination: Destination?  // Destination city and airport
        
        public init(
            origin: Origin?,
            destination: Destination?
        ) {
            self.origin = origin
            self.destination = destination
        }
    }

    public let flight_reservation_details: FlightReservationDetails?
    public let hotel_reservation_details: [HotelReservationDetails]?
    public let insurance_details: [InsuranceDetails]?
    public let payment_history_full: PaymentHistoryFull?
    public let payment_history_simple: PaymentHistorySimple?
    public let flight_points_simple: FlightPointsSimple?
    
    public init(
        flight_reservation_details: FlightReservationDetails?,
        hotel_reservation_details: [HotelReservationDetails]?,
        insurance_details: [InsuranceDetails]?,
        payment_history_full: PaymentHistoryFull?,
        payment_history_simple: PaymentHistorySimple?,
        flight_points_simple: FlightPointsSimple?
    ) {
        self.flight_reservation_details = flight_reservation_details
        self.hotel_reservation_details = hotel_reservation_details
        self.insurance_details = insurance_details
        self.payment_history_full = payment_history_full
        self.payment_history_simple = payment_history_simple
        self.flight_points_simple = flight_points_simple
    }
}

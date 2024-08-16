import Foundation
import XCTest
@testable import Tabby

final class PaymentDecodingTests: XCTestCase {

    func testPaymentDecoding() throws {
        let jsonData = jsonString.data(using: .utf8)!
        let payment = try JSONDecoder().decode(TabbyCheckoutPayload.self, from: jsonData)
        dump(payment)
    }

    private let jsonString: String = """
{
    "payment":{
        "buyer_history":{
            "is_phone_number_verified":true,
            "loyalty_level":1,
            "is_social_networks_connected":true,
            "is_email_verified":true,
            "registered_since":"2018-05-18T10:04:00+00:00",
            "wishlist_count":0
        },
        "buyer":{
            "name":"jaydeep modi",
            "email":"jaydeep.modi@drcsystems.com",
            "phone":"8523697410"
        },
        "order_history":[
            {
                "status":"complete",
                "shipping_address":{
                    "address":"Al Khail Mall - Al Quoz - Al Quoz 4 - Dubai - United Arab Emirates",
                    "zip":"",
                    "city":"Ahemdabad"
                },
                "items":[
                    {
                        "category":"",
                        "quantity":1,
                        "reference_id":"",
                        "discount_amount":0.0,
                        "ordered":1,
                        "title":"Embroidered Long Frock ",
                        "shipped":1,
                        "unit_price":290.0,
                        "refunded":0,
                        "captured":1
                    }
                ],
                "buyer":{
                    "name":"jaydeep modi",
                    "email":"jaydeep.modi@drcsystems.com",
                    "phone":"8523697410"
                },
                "payment_method":"checkmo",
                "purchased_at":"2024-07-19T11:09:12+00:00",
                "amount":320.0
            },
            {
                "status":"canceled",
                "amount":66.67,
                "payment_method":"ccavenue",
                "shipping_address":{
                    "city":"Dubai",
                    "zip":"",
                    "address":"Silver tower ,office no.260"
                },
                "items":[
                    {
                        "ordered":1,
                        "title":"Asymmetrical Long dress",
                        "captured":0,
                        "unit_price":420.0,
                        "quantity":1,
                        "refunded":0,
                        "shipped":0,
                        "reference_id":"",
                        "category":"",
                        "discount_amount":0.0
                    },
                    {
                        "ordered":1,
                        "reference_id":"",
                        "title":"Tulle Long Dress ",
                        "quantity":1,
                        "unit_price":350.0,
                        "captured":0,
                        "category":"",
                        "refunded":0,
                        "shipped":0,
                        "discount_amount":0.0
                    }
                ],
                "buyer":{
                    "email":"jaydeep.modi@drcsystems.com",
                    "phone":"8985856985",
                    "name":"jaydeep modi"
                },
                "purchased_at":"2024-01-11T10:19:12+00:00"
            },
            {
                "status":"canceled",
                "shipping_address":{
                    "address":"sds dis dis c.",
                    "city":"as wad",
                    "zip":""
                },
                "purchased_at":"2023-12-11T11:26:04+00:00",
                "items":[
                    {
                        "category":"",
                        "shipped":0,
                        "ordered":1,
                        "refunded":0,
                        "unit_price":240.0,
                        "quantity":1,
                        "reference_id":"",
                        "discount_amount":0.0,
                        "captured":0,
                        "title":"Wrap over Tulle Dress "
                    }
                ],
                "amount":270.0,
                "buyer":{
                    "name":"jaydeep modi",
                    "email":"jaydeep.modi@drcsystems.com",
                    "phone":"8000190600"
                },
                "payment_method":"checkmo"
            }
        ],
        "order":{
            "discount_amount":0.0,
            "tax_amount":0.0,
            "shipping_amount":30.0,
            "reference_id":"000002524",
            "items":[
                {
                    "discount_amount":0.0,
                    "unit_price":0.0,
                    "quantity":1,
                    "category":"Women Sale",
                    "title":"Embellished Long Dress",
                    "reference_id":"H23630PST.GRNL"
                }
            ]
        },
        "amount":880.0,
        "shipping_address":{
            "city":"Ahemdabad",
            "zip":"384265",
            "address":"Al Khail Mall - Al Quoz - Al Quoz 4 - Dubai - United Arab Emirates"
        },
        "currency":"AED"
    },
    "merchant_code":"uaeapp",
    "lang":"en"
}
"""
}

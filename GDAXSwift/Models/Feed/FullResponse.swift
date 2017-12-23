//
//  FullResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 21/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class FullResponse: Codable {
    var type: String?
    var time: String?
    var product_id: String?
    var sequence: Int?
    var order_id: String?
    var size: String?
    var price: String?
    var side: String?
    var order_type: String?
    var remaining_size: String?
    var reason: String? //filled, // or canceled
    var funds: String?
    var trade_id: Int?
    var maker_order_id: String?
    var taker_order_id: String?
    var new_size: String?
    var old_size: String?
    var new_funds: String?
    var old_funds: String?
    var nonce: Int?
    var position: String?
    var position_size: String?
    var position_compliment: String?
    var position_max_size: String?
    var call_side: String?
    var call_price: String?
    var call_size: String?
    var call_funds: String?
    var covered: Bool?
    var next_expire_time: String?
    var base_balance: String?
    var base_funding: String?
    var quote_balance: String?
    var quote_funding: String?
    var _private: Bool?
    var user_id: String?
    var profile_id: String?
    var taker_fee_rate: String?
    var stop_type: String?
}

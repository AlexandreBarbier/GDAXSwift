//
//  TickerResponse.swift
//  Gdax
//
//  Created by Alexandre Barbier on 01/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class TickerResponse: Codable {
    var sequence:Int?
    var price:String?
    var product_id: String?
    var trade_id: Int?
    var side: String?
    var last_size: String?
    var best_bid: String?
    var best_ask: String?
}

//
//  TradeResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 06/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

class TradeResponse: Codable {
//    var time: "2014-11-07T22:19:28.578544Z",
    var trade_id: Int?
    var price: String?
    var size: String?
    var side: String?
}

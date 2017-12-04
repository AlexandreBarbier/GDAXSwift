//
//  TickerResponse.swift
//  Gdax
//
//  Created by Alexandre Barbier on 01/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

class TickerResponse: Codable {
    var sequence:Int?
    var price:String?
    var product_id: String?
}

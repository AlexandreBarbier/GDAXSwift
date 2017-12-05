//
//  HeartbeatResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 05/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

class HeartbeatResponse: Codable {
    var sequence: Int?
    var last_trade_id: Int?
    var product_id: String?
}

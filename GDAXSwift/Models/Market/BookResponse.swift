//
//  BookResponse.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 06/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

struct baObject: Codable {
    var price: String, size:String, order_id:String?, num_order:Int?
}

class BookResponse: Codable {
    
    var sequence: Int?
    var bids: [[baObject]]?
    var asks: [[baObject]]?

    enum CodingKeys: String, CodingKey {
        case sequence
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sequence = try container.decode(Int.self, forKey: .sequence)
        bids = []
        asks = []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sequence, forKey: .sequence)
    }
}

//
//  GDAX.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 04/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit

open class GDAX: NSObject {
    public static var feed = Feed.client
    public static var market = Market.client
    public static var authenticate = Authenticate.client
}

//
//  Feed.swift
//  Gdax
//
//  Created by Alexandre Barbier on 01/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
import Starscream

enum gdax_products: String {
    case LTC, BTC, ETH
    
    func getProductId(for currency: currency) -> String {
        return "\(self.rawValue)-\(currency.rawValue)"
    }
    
    func getProductId(for product: gdax_products) -> String {
        return "\(self.rawValue)-\(product.rawValue)"
    }
}

enum currency: String {
    case EUR, USD
}

struct GDAXProductsId {
    static let LTC_EUR = gdax_products.LTC.getProductId(for: currency.EUR)
    static let LTC_USD = gdax_products.LTC.getProductId(for: currency.USD)
    static let LTC_BTC = gdax_products.LTC.getProductId(for: gdax_products.BTC)
    
    static let BTC_EUR = gdax_products.BTC.getProductId(for: currency.EUR)
    static let BTC_USD = gdax_products.BTC.getProductId(for: currency.USD)
    
    static let ETH_EUR = gdax_products.ETH.getProductId(for: currency.EUR)
    static let ETH_USD = gdax_products.LTC.getProductId(for: currency.USD)
    static let ETH_BTC = gdax_products.ETH.getProductId(for: gdax_products.BTC)
}

class Feed: NSObject {
    typealias TickerHandler = (_ message: TickerResponse) -> Void
    private let ws = WebSocket(url: URL(string: "wss://ws-feed.gdax.com")!)
    private var requestedMessage: [String] = []
    private var tickerHandler: [String: TickerHandler] = [:]
    static let client = Feed()
    
    private override init() {
        super.init()
        ws.onText = { message in
            let decoder = JSONDecoder()
            
            let da = message.data(using: .utf8)!
            do {
                let k  = try decoder.decode(Response.self, from: da)
                if k.type == "ticker" {
                    let da2 = message.data(using: .utf8)!
                    let tick = try decoder.decode(TickerResponse.self, from: da2)
                    if let handler = self.tickerHandler[tick.product_id!] {
                        handler(tick)
                    }
                }
            } catch {
                
            }
        }
        ws.onConnect = {
            for msg in self.requestedMessage {
                self.ws.write(string: msg)
            }
        }
        ws.connect()
    }

    func subscribeTicker(for product: String, responseHandler: @escaping TickerHandler) {
        tickerHandler[product] = responseHandler
        if ws.isConnected {
            ws.write(string:"{\"type\": \"subscribe\", \"channels\": [{ \"name\": \"ticker\", \"product_ids\": [\"\(product)\"]}]}")
         
        } else {
            requestedMessage.append("{\"type\": \"subscribe\", \"channels\": [{ \"name\": \"ticker\", \"product_ids\": [\"\(product)\"]}]}")
        }
    }
    
    func disconect(product: String) {
        tickerHandler.removeValue(forKey: product)
    }
}

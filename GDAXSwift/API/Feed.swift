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
    typealias HeartbeatHandler = (_ message: HeartbeatResponse) -> Void
    typealias Level2Handler = (_ message: Level2Response) -> Void
    
    private var requestedMessage: [String] = []
    private var tickerHandlers: [String: TickerHandler] = [:]
    private var heartbeatHandlers: [String: HeartbeatHandler] = [:]
    private var level2Handlers: [String: Level2Handler] = [:]
    
    private let ws = WebSocket(url: URL(string: "wss://ws-feed.gdax.com")!)
    
    static let client = Feed()
    
    private override init() {
        super.init()
        ws.onText = { message in
            let decoder = JSONDecoder()
            let response = message.data(using: .utf8)!
            
            do {
                let k  = try decoder.decode(Response.self, from: response)
                if let chanType = k.type, let fType = FeedType(rawValue: chanType) {
                    switch fType {
                    case .ticker:
                        let da2 = message.data(using: .utf8)!
                        let tick = try decoder.decode(TickerResponse.self, from: da2)
                        if let handler = self.tickerHandlers[tick.product_id!] {
                            handler(tick)
                        }
                        break
                    case .heartbeat:
                        let da2 = message.data(using: .utf8)!
                        let heartbeat = try decoder.decode(HeartbeatResponse.self, from: da2)
                        if let handler = self.heartbeatHandlers[heartbeat.product_id!] {
                            handler(heartbeat)
                        }
                        break
                    case .l2update:
                        let da2 = message.data(using: .utf8)!
                        let l2update = try decoder.decode(Level2Response.self, from: da2)
                        if let handler = self.level2Handlers[l2update.product_id!] {
                            handler(l2update)
                        }
                        break
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
    
    private func getSubscription(name: String, product: String) -> String {
        return "{\"type\": \"subscribe\", \"channels\": [{ \"name\": \"\(name)\", \"product_ids\": [\"\(product)\"]}]}"
    }
    
    func subscribeTicker(for product: String, responseHandler: @escaping TickerHandler) {
        tickerHandlers[product] = responseHandler
        if ws.isConnected {
            ws.write(string: getSubscription(name: "ticker", product: product))
        } else {
            requestedMessage.append(getSubscription(name: "ticker", product: product))
        }
    }
    
    func subscribeHeartbeat(for product: String, responseHandler: @escaping HeartbeatHandler) {
        heartbeatHandlers[product] = responseHandler
        if ws.isConnected {
            ws.write(string: getSubscription(name: "heartbeat", product: product))
        } else {
            requestedMessage.append(getSubscription(name: "heartbeat", product: product))
        }
    }
    
    func subscribeLevel2(for product: String, responseHandler: @escaping Level2Handler) {
        level2Handlers[product] = responseHandler
        if ws.isConnected {
            ws.write(string:getSubscription(name: "level2", product: product))
        } else {
            requestedMessage.append(getSubscription(name: "level2", product: product))
        }
    }
    
    func disconect(product: String, channel: FeedType) {
        switch channel {
        case .heartbeat:
            heartbeatHandlers.removeValue(forKey: product)
            break
        case .l2update:
            level2Handlers.removeValue(forKey: product)
            break
        case .ticker:
            tickerHandlers.removeValue(forKey: product)
            break
        }
    }
}

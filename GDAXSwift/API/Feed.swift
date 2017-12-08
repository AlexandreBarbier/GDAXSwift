//
//  Feed.swift
//  Gdax
//
//  Created by Alexandre Barbier on 01/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
import Starscream

public enum gdax_products: String {
    case LTC, BTC, ETH, EUR, USD

    public func getProductId(for product: gdax_products) -> String {
        return "\(self.rawValue)-\(product.rawValue)"
    }
}


public struct GDAXProductsId {
    public static let LTC_EUR = gdax_products.LTC.getProductId(for: gdax_products.EUR)
    public static let LTC_USD = gdax_products.LTC.getProductId(for: gdax_products.USD)
    public static let LTC_BTC = gdax_products.LTC.getProductId(for: gdax_products.BTC)
    
    public static let BTC_EUR = gdax_products.BTC.getProductId(for: gdax_products.EUR)
    public static let BTC_USD = gdax_products.BTC.getProductId(for: gdax_products.USD)
    
    public static let ETH_EUR = gdax_products.ETH.getProductId(for: gdax_products.EUR)
    public static let ETH_USD = gdax_products.LTC.getProductId(for: gdax_products.USD)
    public static let ETH_BTC = gdax_products.ETH.getProductId(for: gdax_products.BTC)
}

public struct gdax_value {
    public var from: gdax_products
    public var to: gdax_products

    public init(from:gdax_products, to: gdax_products) {
        self.from = from
        self.to = to
    }
}

open class Feed: NSObject {
    public typealias TickerHandler = (_ message: TickerResponse) -> Void
    public typealias HeartbeatHandler = (_ message: HeartbeatResponse) -> Void
    public typealias Level2Handler = (_ message: Level2Response) -> Void
    
    private var requestedMessage: [String] = []
    private var tickerHandlers: [String: TickerHandler] = [:]
    private var heartbeatHandlers: [String: HeartbeatHandler] = [:]
    private var level2Handlers: [String: Level2Handler] = [:]
    
    private let ws = WebSocket(url: URL(string: "wss://ws-feed.gdax.com")!)
    private var openingSocket = false
    public static let client = Feed()
    public var errorHandler: ((_ error: Error?) -> Void)?
    public var isConnected: Bool { return ws.isConnected }

    public var onConnectionChange:((_ connected: Bool) -> Void)?

    private override init() {
        super.init()
        ws.onText = { message in
            guard let response = message.data(using: .utf8) else {
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let k  = try decoder.decode(Response.self, from: response)
                guard let da2 = message.data(using: .utf8),
                    let chanType = k.type,
                    let fType = FeedType(rawValue: chanType) else {
                        return
                }
                switch fType {
                case .ticker:
                    let tick = try decoder.decode(TickerResponse.self, from: da2)
                    if let handler = self.tickerHandlers[tick.product_id!] {
                        handler(tick)
                    }
                    break
                case .heartbeat:
                    let heartbeat = try decoder.decode(HeartbeatResponse.self, from: da2)
                    if let handler = self.heartbeatHandlers[heartbeat.product_id!] {
                        handler(heartbeat)
                    }
                    break
                case .l2update:
                    let l2update = try decoder.decode(Level2Response.self, from: da2)
                    if let handler = self.level2Handlers[l2update.product_id!] {
                        handler(l2update)
                    }
                    break
                }
            } catch {
                
            }
        }
        ws.onConnect = {
            self.openingSocket = false
            self.onConnectionChange?(self.isConnected)
            for msg in self.requestedMessage {
                self.ws.write(string: msg)
            }
        }
        ws.onDisconnect = { error in
            self.onConnectionChange?(self.isConnected)
            self.errorHandler?(error)
        }
        ws.connect()
        openingSocket = true
    }
    
    private func getSubscription(name: String, product: [String]) -> String {
        return "{\"type\": \"subscribe\", \"channels\": [{ \"name\": \"\(name)\", \"product_ids\": [\"\(product.joined(separator: ","))\"]}]}"
    }

    fileprivate func subscribe(_ prods: [String],_ name: String) {
        let msg = getSubscription(name: name, product: prods)
        !ws.isConnected && !openingSocket ? ws.connect() : ()
        ws.isConnected ? ws.write(string:msg) : requestedMessage.append(msg)
    }

    public func subscribeTicker(for products: [gdax_value], responseHandler: @escaping TickerHandler) {
        let prods:[String] = products.map({
            let res = $0.from.getProductId(for: $0.to)
            tickerHandlers[res] = responseHandler
            return res
        })
        subscribe(prods, "ticker")
    }
    
    public func subscribeHeartbeat(for products: [gdax_value], responseHandler: @escaping HeartbeatHandler) {
        let prods:[String] = products.map({
            let res = $0.from.getProductId(for: $0.to)
            heartbeatHandlers[res] = responseHandler
            return res
        })
        subscribe(prods, "heartbeat")
    }

    public func subscribeLevel2(for products: [gdax_value], responseHandler: @escaping Level2Handler) {
        let prods:[String] = products.map({
            let res = $0.from.getProductId(for: $0.to)
            level2Handlers[res] = responseHandler
            return res
        })
        subscribe(prods, "level2")
    }
    
    public func disconectFrom(channel: FeedType, product: String) {
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

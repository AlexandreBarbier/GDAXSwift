//
//  GDAXSwiftTests.swift
//  GDAXSwiftTests
//
//  Created by Alexandre Barbier on 04/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import XCTest
@testable import GDAXSwift

class GDAXSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTicker() {
        let expect = expectation(description:"")
        
        GDAX.feed.subscribeTicker(for: gdax_value(from:.LTC, to:.BTC)) { (message) in
            GDAX.feed.disconectFrom(channel: .ticker, product: GDAXProductsId.LTC_BTC)
            XCTAssert(message.product_id == "LTC-BTC")            
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }
    
    func testHeartbeat() {
        let expect = expectation(description:"")
        
        GDAX.feed.subscribeHeartbeat(for: gdax_value(from:.LTC, to:.BTC)) { (message) in
            GDAX.feed.disconectFrom(channel: .heartbeat, product: GDAXProductsId.LTC_BTC)
            XCTAssert(message.product_id == "LTC-BTC")
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testProductlevel1() {
        let expect = expectation(description:"")

        GDAX.market.product(productId: "BTC-USD").getBook { (response) in
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testProductlevel2() {
        let expect = expectation(description:"")

        GDAX.market.product(productId: "BTC-USD").getBook(level: 2) { (response) in
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testProductlevel3() {
        let expect = expectation(description:"")

        GDAX.market.product(productId: "BTC-USD").getBook(level: 3) { (response) in
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testProductTrades() {
        let expect = expectation(description:"")

        GDAX.market.product(productId: "BTC-USD").getTrades { (response, error) in
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testLevel2() {
        let expect = expectation(description:"")
        
        GDAX.feed.subscribeLevel2(for: gdax_value(from: .LTC, to: .BTC)) { (message) in
            GDAX.feed.disconectFrom(channel: .l2update, product: GDAXProductsId.LTC_BTC)
            XCTAssert(message.product_id == "LTC-BTC")
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

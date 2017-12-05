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
        
        GDAX.feed.subscribeTicker(for: GDAXProductsId.LTC_BTC) { (message) in
            GDAX.feed.disconect(product: GDAXProductsId.LTC_BTC, channel: .ticker)
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
        
        GDAX.feed.subscribeHeartbeat(for: GDAXProductsId.LTC_BTC) { (message) in
            GDAX.feed.disconect(product: GDAXProductsId.LTC_BTC, channel: .heartbeat)
            XCTAssert(message.product_id == "LTC-BTC")
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
        
        GDAX.feed.subscribeLevel2(for: GDAXProductsId.LTC_BTC) { (message) in
            GDAX.feed.disconect(product: GDAXProductsId.LTC_BTC, channel: .l2update)
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

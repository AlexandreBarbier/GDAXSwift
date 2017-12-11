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
        //put your credentials here (GDAX API key secret etc)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTicker() {
        let expect = expectation(description:"")
        
        let sub = GDAX.feed.subscribeTicker(for: [gdax_value(from:.LTC, to:.BTC)]) { (message) in
            XCTAssert(message.product_id == "LTC-BTC")            
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            sub.unsubscribe()
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }
    
    func testHeartbeat() {
        let expect = expectation(description:"")
        
        let sub = GDAX.feed.subscribeHeartbeat(for: [gdax_value(from:.LTC, to:.BTC)]) { (message) in
            XCTAssert(message.product_id == "LTC-BTC")
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            sub.unsubscribe()
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testProductlevel1() {
        let expect = expectation(description:"")

        GDAX.market.product(productId: "LTC-EUR").getBook { (response) in
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

        GDAX.market.product(productId: "LTC-EUR").getBook(level: 2) { (response) in
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

        GDAX.market.product(productId: "LTC-EUR").getBook(level: 3) { (response) in
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

        GDAX.market.product(productId: "LTC-EUR").getTrades { (response, error) in
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testProductStats() {
        let expect = expectation(description:"")

        GDAX.market.product(productId: "LTC-EUR").get24hStats { (response, error) in
            XCTAssert(response != nil)
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }


    func testProductLastTick() {
        let expect = expectation(description:"")

        GDAX.market.product(productId: "LTC-EUR").getLastTick { (response, error) in
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
        
        let sub = GDAX.feed.subscribeLevel2(for: [gdax_value(from: .LTC, to: .EUR)]) { (message) in

            XCTAssert(message.product_id == "LTC-EUR")
            expect.fulfill()

        }
        waitForExpectations(timeout:5.0) { (error) in
            sub.unsubscribe()
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

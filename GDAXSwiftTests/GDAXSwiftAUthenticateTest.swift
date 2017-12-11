//
//  GDAXSwiftAUthenticateTest.swift
//  GDAXSwiftTests
//
//  Created by Alexandre Barbier on 08/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import XCTest
@testable import GDAXSwift

class GDAXSwiftAUthenticateTest: XCTestCase {
    override func setUp() {
        super.setUp()
        //put your credentials here (GDAX API key secret etc)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAccounts() {
        let expect = expectation(description: "")
        GDAX.authenticate.getAccounts { accounts, error in
            XCTAssert(accounts != nil && accounts!.count > 0)
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testAccount() {
        let expect = expectation(description: "")
        GDAX.authenticate.getAccounts { accounts, error in
            guard let accounts = accounts else {
                expect.fulfill()
                return
            }
            GDAX.authenticate.getAccount(accountId: accounts.first!.id!) { account, error in
                XCTAssert(account != nil && account!.id == accounts.first!.id!)
                expect.fulfill()
            }
        }

        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testAccountHistory() {
        let expect = expectation(description: "")
        GDAX.authenticate.getAccounts { accounts, error in
            GDAX.authenticate.getAccountHistory(accountId: accounts!.first!.id!) { activities, error in
                XCTAssert(activities != nil)
                expect.fulfill()
            }
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testAccountHolds() {
        let expect = expectation(description: "")
        GDAX.authenticate.getAccounts { accounts, error in
            GDAX.authenticate.getAccountHolds(accountId: accounts!.first!.id!) { holds, error in
                XCTAssert(holds != nil)
                expect.fulfill()
            }
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testGetOrders() {
        let expect = expectation(description: "")
        GDAX.authenticate.getOrders(status: "all") { (orders, error) in
            XCTAssert(orders != nil && orders!.count > 0)
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testPostOrder() {
        let expect = expectation(description: "")
        let order = Order()
        order.price = "4887.50"
        order.type = "limit"
        order.post_only = true
        order.side = "buy"
        order.size = "1.0"
        order.product_id = "BTC-USD"
        GDAX.authenticate.postOrder(order: order) { (response, error) in
            expect.fulfill()
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }

    func testCancelOrder() {
        let expect = expectation(description: "")
        GDAX.authenticate.getOrders(status: "open") { (orders, error) in
            GDAX.authenticate.cancelOrder(orderId: orders!.first!.id!, completion: { (orders, error) in
                expect.fulfill()
            })
        }
        waitForExpectations(timeout:5.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }
}

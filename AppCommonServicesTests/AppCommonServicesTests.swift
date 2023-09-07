//
//  AppCommonServicesTests.swift
//  AppCommonServicesTests
//
//  Created by 9OSU1G02 on 9/6/23.
//

import XCTest
import StoreKitTest
import SwiftKeychainWrapper
@testable import AppCommonServices

final class AppCommonServicesTests: XCTestCase {
    var products = [SKProduct] ()
    override func setUpWithError() throws {
        if products.count > 0 {
          return
        }
        let session = try SKTestSession(configurationFileNamed: "Configuration")
        session.disableDialogs = true
        session.clearTransactions()
        let store = IAPStore(productIdentifiers: OwlProducts.productIDsNonConsumables)
        store.requestProducts()
        let loadProductsExpectation = expectation(description: "load products")
        let result = XCTWaiter.wait(for: [loadProductsExpectation], timeout: 2)
        if result == XCTWaiter.Result.timedOut {
          products = store.products
        }
      }


    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIAPStore_buyProduct() throws {
        let product = products.first!
        KeychainWrapper.standard.removeAllKeys()
        XCTAssertNil(KeychainWrapper.standard.integer(forKey: product.productIdentifier))
        let store = IAPStore(productIdentifiers: OwlProducts.productIDsNonConsumables)
        store.buyProduct(product: product)
        let purchaseExpectation = expectation(description: "test after a second")
        let result = XCTWaiter.wait(for: [purchaseExpectation], timeout: 2)
        if result == XCTWaiter.Result.timedOut {
            let isOwned = KeychainWrapper.standard.bool(forKey: product.productIdentifier)
            XCTAssert(isOwned != nil && isOwned! == true)
        }
    }

}

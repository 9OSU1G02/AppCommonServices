//
//  IAPStore.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 9/6/23.
//

import StoreKit
import SwiftKeychainWrapper
class IAPStore: NSObject, ObservableObject {
    private var productsRequest: SKProductsRequest?
    private let productIdentifiers: Set<String>
    var purchasedProducts: Set<String> = []
    @Published private(set) var products: [SKProduct] = []

    internal init(productIdentifiers: Set<String>) {
        self.productIdentifiers = productIdentifiers
        purchasedProducts = Set(productIdentifiers.filter { KeychainWrapper.standard.bool(forKey: $0) ?? false })
    }
    
    func requestProducts() {
        productsRequest?.cancel()
        productsRequest = .init(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    func buyProduct(product: SKProduct) {
        SKPaymentQueue.default().add(.init(product: product))
    }

    func addPurchase(purchaseIdentifier: String) {
        if productIdentifiers.contains(purchaseIdentifier) {
            purchasedProducts.insert(purchaseIdentifier)
            KeychainWrapper.standard.set(true, forKey: purchaseIdentifier)
            objectWillChange.send()
        }
    }
    
    func decrementConsumable(productIdentifier: String) {
        var currentTotal = consumableAmountFor(productIdentifier: productIdentifier)
        if currentTotal > 0 {
          currentTotal -= 1
        }
        KeychainWrapper.standard.set(currentTotal, forKey: productIdentifier)
        objectWillChange.send()
      }
    
    func isPurchased(_ productIdenfifier: String) -> Bool {
        return purchasedProducts.contains(productIdenfifier)
    }
    
    func restorePurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func addConsumable(productIdentifier: String, amount: Int) {
        var currentTotal = consumableAmountFor(productIdentifier: productIdentifier)
        currentTotal += amount
        KeychainWrapper.standard.set(currentTotal, forKey: productIdentifier)
        objectWillChange.send()
      }

      func consumableAmountFor(productIdentifier: String) -> Int {
        KeychainWrapper.standard.integer(forKey: productIdentifier) ?? 0
      }
}

extension IAPStore: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async { self.products = response.products }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed getting products:", error.localizedDescription)
    }
}

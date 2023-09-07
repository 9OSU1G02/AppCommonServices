//
//  IAPStoreV2.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 9/7/23.
//

import StoreKit
import SwiftKeychainWrapper
class IAPStoreV2: ObservableObject {
    private let productIdentifiers: Set<String>
    @Published private(set) var products: [Product] = []
    
    // use for finish transaction when something wrong happend
    private var task: Task<Void, Never>!
    
    var purchasedProducts: Set<String> = []
    internal init(productIdentifiers: Set<String>) {
        self.productIdentifiers = productIdentifiers
        task = Task.detached(operation: { [unowned self] in
            for await result in Transaction.updates {
                await processTransaction(result: result)
            }
        })
    }
    
    deinit {
        task.cancel()
    }

    @MainActor
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIdentifiers)
        } catch {
            print("Failed to load products ", error.localizedDescription)
        }
    }
    
    func buyProduct(product: Product) async {
        do {
            if case .success(let result) = try await product.purchase() {
                await processTransaction(result: result)
            }
        } catch {
            print("Failed to buy product ", error.localizedDescription)
        }
    }
    
    func isPurchased(_ productIdenfifier: String) -> Bool {
        return purchasedProducts.contains(productIdenfifier)
    }
    
    func restorePurchase() async {
        for await result in Transaction.currentEntitlements {
            await processTransaction(result: result)
        }
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
    
    func decrementConsumable(productIdentifier: String) {
        var currentTotal = consumableAmountFor(productIdentifier: productIdentifier)
        if currentTotal > 0 {
            currentTotal -= 1
        }
        KeychainWrapper.standard.set(currentTotal, forKey: productIdentifier)
        objectWillChange.send()
    }
    
    func addPurchase(purchaseIdentifier: String) {
        if productIdentifiers.contains(purchaseIdentifier) {
            purchasedProducts.insert(purchaseIdentifier)
            KeychainWrapper.standard.set(true, forKey: purchaseIdentifier)
            objectWillChange.send()
        }
    }
    
    @MainActor
    private func processTransaction(result: VerificationResult<Transaction>) {
        do {
            if case .verified(let transaction) = result {
                if OwlProducts.isConsumable(productIdentifier: transaction.productID) {
                    addConsumable(productIdentifier: transaction.productID, amount: 3)
                } else {
                    addPurchase(purchaseIdentifier: transaction.productID)
                }
            }
            let transaction = try result.payloadValue
            Task {
                await transaction.finish()
            }
        } catch {
            print("Failed to processTransaction ", error.localizedDescription)
        }
    }
}

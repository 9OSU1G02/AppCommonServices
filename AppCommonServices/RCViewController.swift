//
//  RCViewController.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 9/8/23.
//

import RevenueCat
import UIKit

class RCViewController: UIViewController {
    var products: [StoreProduct] = []
    var purchasedProductIDs: Set<String> = []
    @IBOutlet weak var restorePurchase: UIButton!
    @IBOutlet var productTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.register(.init(nibName: "RCProductCellTableViewCell", bundle: .main), forCellReuseIdentifier: "123")
        productTableView.delegate = self
        productTableView.dataSource = self
        Purchases.shared.delegate = self
        let group = DispatchGroup()
        group.enter()
        Purchases.shared.getProducts(Array(OwlProducts.allProducts)) { [weak self] storeProduct in
            group.leave()
            guard let self, !storeProduct.isEmpty else {
                print("--> failed to get product")
                return
            }
            products = storeProduct
        }
        group.enter()
        Purchases.shared.getCustomerInfo { [weak self] info, _ in
            group.leave()
            guard let self = self, let info = info else {
                print("--> failed to getCustomerInfo")
                return
            }
            purchasedProductIDs = info.allPurchasedProductIdentifiers
        }
        
        group.notify(queue: .main) { [weak self] in
            print("--> all done")
            self?.productTableView.reloadData()
        }
    }
    @IBAction func onTapRestorePurchase(_ sender: UIButton) {
        Purchases.shared.restorePurchases { [weak self] info, error in
            guard let info, let self else { return }
            purchasedProductIDs = info.allPurchasedProductIdentifiers
            productTableView.reloadData()
        }
    }
}

extension RCViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "123") as! RCProductCellTableViewCell
        let product = products[indexPath.row]
        let isPurchased = purchasedProductIDs.contains(product.productIdentifier)
        cell.setup(name: product.localizedTitle, price: product.localizedPriceString, isPurchased: isPurchased)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Purchases.shared.purchase(product: products[indexPath.row]) { transaction, info, error, bool in
            print("--> transaction ", transaction)
            print("--> info ", info)
            print("--> error ", error)
            print("--> bool ", bool)
        }
    }
}

extension RCViewController: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        print("--> purchases ", purchases)
        print("--> customerInfo ", customerInfo)
        purchasedProductIDs = customerInfo.allPurchasedProductIdentifiers
        productTableView.reloadData()
    }
    
    func purchases(_ purchases: Purchases, readyForPromotedProduct product: StoreProduct, purchase startPurchase: @escaping StartPurchaseBlock) {
        print("--> purchases readyForPromotedProduct", purchases)
    }
}

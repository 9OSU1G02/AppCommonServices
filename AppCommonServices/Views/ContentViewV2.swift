//
//  ContentViewV2.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 9/7/23.
//

import StoreKit
import SwiftUI
struct ContentViewV2: View {
    @EnvironmentObject var store: IAPStoreV2
    var body: some View {
        NavigationView {
            List {
                ForEach(store.products, id: \.self) { product in
                    ZStack {
                        ProductRowV2(product: product)
                        if !OwlProducts.isConsumable(productIdentifier: product.id) {
                            NavigationLink(destination: OwlDLCViewV2(product: product)) {
                                EmptyView()
                            }
                            .frame(width: 0)
                            .opacity(0)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Insomni Owl")
            .navigationBarItems(trailing: Button("Restore", action: {
                Task { await store.restorePurchase() }
            }))
            .task {
                await store.requestProducts()
            }
        }
    }

    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "Background-StaryNight"), for: UIBarMetrics.default)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
    }
}

struct ContentView_PreviewsV2: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ProductRowV2: View {
    @EnvironmentObject var store: IAPStoreV2
    @State var isPresented = false
    let product: Product
    init(product: Product) {
        self.product = product
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: nil) {
                Text("\(product.displayName) - \(product.displayPrice)")
                Text(product.description)
            }
            Spacer()
            if OwlProducts.isConsumable(productIdentifier: product.id) {
                if store.consumableAmountFor(productIdentifier: product.id) > .zero {
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "\(store.consumableAmountFor(productIdentifier: product.id)).circle")
                            .font(.system(.largeTitle))
                    }

                } else {
                    PurchaseButtonV2(product: product)
                }
            } else {
                if store.isPurchased(product.id) {
                    OwnedView()
                } else {
                    PurchaseButtonV2(product: product)
                }
            }
        }
        .padding()
        .alert(isPresented: $isPresented) {
            let purchaseOwl = Alert.Button.default(.init("Yes")) {
                let randomOwl = OwlProducts.fetchRandomUnownedProduct(ownedProducts: store.purchasedProducts)
                store.decrementConsumable(productIdentifier: product.id)
                store.addPurchase(purchaseIdentifier: randomOwl)
            }
            return Alert(title: .init("Unlock Random Owl"), message: .init("Do you wish to unlock a random owl?"), primaryButton: purchaseOwl, secondaryButton: .cancel(.init("No")))
        }
    }
}

struct OwnedViewV2: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Image(systemName: "checkmark")
            .padding(10)
            .foregroundColor(colorScheme == .light ? .black : .white)
            .overlay(
                Circle()
                    .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 2)
            )
    }
}

struct PurchaseButtonV2: View {
    let product: Product
    @EnvironmentObject var store: IAPStoreV2
    var body: some View {
        HStack {
            Image(systemName: "cart")
            Text("Buy")
        }
        .onTapGesture {
            Task {
                await store.buyProduct(product: product)
            }
        }
        .padding(10)
        .foregroundColor(.yellow)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.yellow, lineWidth: 2)
        )
    }
}

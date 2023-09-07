//
//  OwlDLCViewV2.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 9/7/23.
//

import SwiftUI
import StoreKit
struct OwlDLCViewV2: View {
    @EnvironmentObject var store: IAPStoreV2
    var product: Product?
    let defaultText = "No Cash, No Owl!"
    let defaultImage = "CouchOwl"
    var body: some View {
        VStack {
          Text(product != nil && store.isPurchased(product!.id) ? product!.displayName : defaultText)
          Image(product != nil && store.isPurchased(product!.id) ? imageFor(product: product!) : defaultImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
        }
      }

    
    private func imageFor(product: Product) -> String {
        let components = product.id.components(separatedBy: ".")
        return components[components.count - 1]
    }
}

struct OwlDLCView_PreviewsV2: PreviewProvider {
  static var previews: some View {
    OwlDLCView()
  }
}



import SwiftUI
import StoreKit

struct OwlDLCView: View {
    @EnvironmentObject var store: IAPStore
    var product: SKProduct?
    let defaultText = "No Cash, No Owl!"
    let defaultImage = "CouchOwl"
    var body: some View {
        VStack {
          Text(product != nil && store.isPurchased(product!.productIdentifier) ? product!.localizedTitle : defaultText)
          Image(product != nil && store.isPurchased(product!.productIdentifier) ? imageFor(product: product!) : defaultImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
        }
      }

    
    private func imageFor(product: SKProduct) -> String {
        let components = product.productIdentifier.components(separatedBy: ".")
        return components[components.count - 1]
    }
}

struct OwlDLCView_Previews: PreviewProvider {
  static var previews: some View {
    OwlDLCView()
  }
}

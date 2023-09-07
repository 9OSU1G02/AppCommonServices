//
//  ContentViewController.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 9/6/23.
//

import UIKit
import SwiftUI

class ContentViewController: UIHostingController<SwiftUI.ModifiedContent<AppCommonServices.ContentView, SwiftUI._EnvironmentKeyWritingModifier<Swift.Optional<AppCommonServices.IAPStore>>>> {
    required init?(coder aDecoder: NSCoder) {
        let store = IAPStore(productIdentifiers: OwlProducts.productIDsNonConsumables.union(OwlProducts.productIDsConsumables))
        (UIApplication.shared.delegate as? AppDelegate)?.store = store
        let contentView = ContentView().environmentObject(store) as! ModifiedContent<ContentView, _EnvironmentKeyWritingModifier<Optional<IAPStore>>>
        super.init(coder: aDecoder, rootView: contentView)
    }
}

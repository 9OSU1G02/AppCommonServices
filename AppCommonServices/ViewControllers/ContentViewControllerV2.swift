//
//  ContentViewControllerV2.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 9/7/23.
//

import Foundation

import UIKit
import SwiftUI

class ContentViewControllerV2: UIHostingController<SwiftUI.ModifiedContent<AppCommonServices.ContentViewV2, SwiftUI._EnvironmentKeyWritingModifier<Swift.Optional<AppCommonServices.IAPStoreV2>>>> {
    required init?(coder aDecoder: NSCoder) {
        let store = IAPStoreV2(productIdentifiers: OwlProducts.productIDsNonConsumables.union(OwlProducts.productIDsConsumables))
        let contentView = ContentViewV2().environmentObject(store) as! ModifiedContent<ContentViewV2, _EnvironmentKeyWritingModifier<Optional<IAPStoreV2>>>
        super.init(coder: aDecoder, rootView: contentView)
    }
}

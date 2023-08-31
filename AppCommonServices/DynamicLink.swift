//
//  DynamicLink.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 8/31/23.
//

import UIKit
import FirebaseDynamicLinks

extension SceneDelegate {
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            print("---> dynamiclink ", dynamiclink?.url?.absoluteString ?? "")
        }
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("---> openURLContexts ", URLContexts.first!.url.absoluteString)
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      let handled = DynamicLinks.dynamicLinks()
        .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
          // ...
        }

      return handled
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return application(app, open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                         annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
          print("dynamicLink", dynamicLink.url?.absoluteString ?? "")
        return true
      }
      return false
    }
}

class DynamicLinkFactory {
    static func createDynamicLink() {
        guard let link = URL(string: "https://www.youtube.com/@swiftarcade7632") else { return }
        let dynamicLinksDomainURIPrefix = "https://appcommonservices.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "gosu1902.AppCommonServices")
        linkBuilder?.iOSParameters?.appStoreID = "6463804814"
        guard let longDynamicLink = linkBuilder?.url else { return }
        print("---> The long URL is: \(longDynamicLink)")
        linkBuilder?.shorten(completion: { url, _, _ in
            print("---> The short URL is:", url?.absoluteString ?? "")
        })
    }
}

//
//  RemoteConfig.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 8/31/23.
//

import FirebaseAnalytics
import FirebaseCore
import FirebaseCrashlytics
import FirebaseRemoteConfig

class RemoteConfigUtil {
    static let remoteConfig: RemoteConfig = {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
        return remoteConfig
    }()

    static func fetchRemoteKey() {
        remoteConfig.fetchAndActivate { status, error in
            if status != .error {
                print("config fetched!", remoteConfig.configValue(forKey: "holiday_promo_enabled").boolValue)
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}

enum CrashlyticsUtil {
    static func forceCrash() {
        Crashlytics.crashlytics().setCustomValue(1902, forKey: "birthday")
        Crashlytics.crashlytics().log("Force Crash")
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("The request failed.", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("The response returned a 404.", comment: ""),
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Does this page exist?", comment: ""),
            "ProductID": "123456",
            "View": "MainView"
        ]

        let error = NSError(domain: NSCocoaErrorDomain,
                            code: -1001,
                            userInfo: userInfo)
        let error2 = NSError(domain: NSCocoaErrorDomain,
                             code: -1002,
                             userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
        Crashlytics.crashlytics().record(error: error2)
        fatalError("Force Crash123")
    }
}

enum EventTracking {
    static func log(name: String, parameters: [String: Any]) {
        Analytics.logEvent(AnalyticsEventSearch, parameters: [AnalyticsParameterSuccess: "1"])
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "id-\(1902)",
          AnalyticsParameterItemName: "1902",
          AnalyticsParameterContentType: "cont",
        ])
        Analytics.logEvent("share_image", parameters: [
          "name": "9osu1g02",
          "full_text": "cat",
        ])
        Analytics.logEvent(name, parameters: parameters)
    }
}

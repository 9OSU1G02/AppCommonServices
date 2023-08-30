//
//  UserDefaults.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 8/28/23.
//

import Foundation
extension UserDefaults {
    // 1
    static let suiteName = "group.gosu1902.AppCommonServices"
    static let extensions = UserDefaults(suiteName: suiteName)!

    // 2
    private enum Keys {
        static let badge = "badge"
    }

    // 3
    var badge: Int {
        get {
            return UserDefaults.extensions.integer(forKey: Keys.badge)
        }

        set {
            UserDefaults.extensions.set(newValue, forKey: Keys.badge)
        }
    }
}

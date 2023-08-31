//
//  AppDelegate.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 8/25/23.
//

import FirebaseCore
import FirebaseMessaging
import UIKit
import FirebaseDynamicLinks
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let categoryIdentifier = "ShowMap"
    private enum ActionIdentifier: String {
        case comment
        case accept
        case cancel
        case payment
        var title: String {
            switch self {
            case .comment:
                return "Comment"
            case .accept:
                return "Accept"
            case .cancel:
                return "Cancel"
            case .payment:
                return "Payment"
            }
        }
        
        var icon: UNNotificationActionIcon {
            switch self {
            case .comment:
                return .init(systemImageName: "bubble")
            case .accept:
                return .init(systemImageName: "checkmark")
            case .cancel:
                return .init(systemImageName: "xmark")
            case .payment:
                return .init(systemImageName: "dollarsign.circle.fill")
            }
        }
    }

    private var rootViewController: UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .first as? UIWindowScene
        return scene?
            .windows.first(where: { $0.isKeyWindow })?.rootViewController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotification(application: application)
        registerCustomActions()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("deviceToken", token)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }

    func registerForPushNotification(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
            guard granted else { return }
            center.delegate = self
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

    private func registerCustomActions() {
        let comment = UNTextInputNotificationAction(identifier: ActionIdentifier.comment.rawValue, title: ActionIdentifier.comment.title, options: .authenticationRequired, icon: ActionIdentifier.comment.icon)
        let payment = UNNotificationAction(identifier: ActionIdentifier.payment.rawValue, title: ActionIdentifier.payment.title, options: .authenticationRequired, icon: ActionIdentifier.payment.icon)
        let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [comment, payment], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "hiddenPreviewsBodyPlaceholder", categorySummaryFormat: "AOR", options: [.hiddenPreviewsShowTitle])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        let identity = response.notification.request.content.categoryIdentifier
        guard identity == categoryIdentifier, let action = ActionIdentifier(rawValue: response.actionIdentifier) else {
            return
        }
        print("categoryIdentifier", categoryIdentifier, "action", action)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let text = userInfo["text"] as? String, let image = userInfo["image"] as? String, let url = URL(string: image) else {
            completionHandler(.noData)
            return
        }
        print("url", url, "text", text)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken", fcmToken ?? "")
    }
}

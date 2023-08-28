//
//  NotificationService.swift
//  PayloadModification
//
//  Created by 9OSU1G02 on 8/28/23.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "Your Target"
            bestAttemptContent.body = "This is your next assignment."
            if let urlPath = request.content.userInfo["media-url"] as? String,
               let url = URL(string: urlPath)
            {
                let destination = URL(fileURLWithPath: NSTemporaryDirectory())
                    .appendingPathComponent(url.lastPathComponent).appendingPathExtension("png")

                do {
                    let data = try Data(contentsOf: url)
                    try data.write(to: destination)

                    let attachment = try UNNotificationAttachment(
                        identifier: "",
                        url: destination)

                    bestAttemptContent.attachments = [attachment]
                } catch {}
            }
            if let incr = bestAttemptContent.badge as? Int {
                switch incr {
                case 0:
                    UserDefaults.extensions.badge = 0
                    bestAttemptContent.badge = 0
                default:
                    let current = UserDefaults.extensions.badge
                    let new = current + incr
                    UserDefaults.extensions.badge = new
                    bestAttemptContent.badge = .init(value: new)
                }
            }
            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}

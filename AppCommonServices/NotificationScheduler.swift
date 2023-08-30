

import UIKit
import UserNotifications

protocol NotificationScheduler {
    func scheduleNotification(trigger: UNNotificationTrigger, titleTextField: UITextField, sound: Bool, badge: String?)
}

extension NotificationScheduler where Self: UIViewController {
    func scheduleNotification(trigger: UNNotificationTrigger, titleTextField: UITextField, sound: Bool, badge: String?) {
        let ws = CharacterSet.whitespacesAndNewlines

        guard let title = titleTextField.text?.trimmingCharacters(in: ws),
              !title.isEmpty
        else {
            UIAlertController.okWithMessage("Please specify a title.",
                                            presentingViewController: self)
            return
        }
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "ShowMap"
        content.title = title
        if sound {
            content.sound = UNNotificationSound.default
        }
        if let badge = badge, let number = Int(badge) {
            content.badge = .init(value: number)
        }
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { [weak self] _ in
            UNUserNotificationCenter.current().add(request) {
                [weak self] error in

                guard let self = self else { return }

                if let error = error {
                    DispatchQueue.main.async {
                        let message = """
                          Failed to schedule notification.
                          \(error.localizedDescription)
                        """
                        UIAlertController.okWithMessage(message,
                                                        presentingViewController: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(
                            animated: true)
                    }
                }
            }
        }
    }
}

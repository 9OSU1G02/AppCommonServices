//
//  NotificationViewController.swift
//  CustomNotificationUI
//
//  Created by 9OSU1G02 on 8/28/23.
//

import MapKit
import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    private enum ActionIdentifier: String {
        case comment
        case accept
        case cancel
        var title: String {
            switch self {
            case .comment:
                return "Comment"
            case .accept:
                return "Accept"
            case .cancel:
                return "Cancel"
            }
        }

        var icon: UNNotificationActionIcon {
            switch self {
            case .comment:
                return .init(systemImageName: "bubble")
            case .accept:
                return .init(systemImageName: "checkmark")
            case .cancel:
                return .init(systemImageName: "bubble")
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    var mediaPlayPauseButtonType: UNNotificationContentExtensionMediaPlayPauseButtonType {
        return .default
    }
    
    var mediaPlayPauseButtonFrame: CGRect {
        return .init(origin: view.center, size: .init(width: 44, height: 44))
    }
    
    var mediaPlayPauseButtonTintColor: UIColor {
        return .purple
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard let latitude = userInfo["latitude"] as? CLLocationDistance,
              let longitude = userInfo["longitude"] as? CLLocationDistance,
              let radius = userInfo["radius"] as? CLLocationDistance
        else {
            return
        }

        let location = CLLocation(latitude: latitude,
                                  longitude: longitude)
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: radius,
                                        longitudinalMeters: radius)
        mapView.setRegion(region, animated: false)
        let acceptAction = UNNotificationAction(
          identifier: ActionIdentifier.accept.rawValue,
          title: ActionIdentifier.accept.title)
        extensionContext?.notificationActions.append(contentsOf: [acceptAction])
        
        var images: [UIImage] = []
        notification.request.content.attachments.forEach { attachment in
            if attachment.url.startAccessingSecurityScopedResource() {
                if let data = try? Data(contentsOf: attachment.url), let image = UIImage(data: data) {
                    images.append(image)
                }
                attachment.url.stopAccessingSecurityScopedResource()
            }
        }
        imageView.image = images.first
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
         
        let accept = ActionIdentifier.accept
        let cancel = ActionIdentifier.cancel
        switch response.actionIdentifier {
        case accept.rawValue:
            let cancelAction = UNTextInputNotificationAction(identifier: cancel.rawValue, title: cancel.title)
            let currentActions = extensionContext?.notificationActions ?? []
            extensionContext?.notificationActions = currentActions.map { $0.identifier == accept.rawValue ? cancelAction : $0 }
        case cancel.rawValue:
            let aceeptAction = UNTextInputNotificationAction(identifier: accept.rawValue, title: accept.title)
            let currentActions = extensionContext?.notificationActions ?? []
            extensionContext?.notificationActions = currentActions.map { $0.identifier == cancel.rawValue ? aceeptAction : $0 }
        default:
            break
        }
        becomeFirstResponder()
        extensionContext?.dismissNotificationContentExtension()
        //completion(.dismiss)
    }
    
    private lazy var paymentView: PaymentView = {
      let paymentView = PaymentView()
      paymentView.onPaymentRequested = { [weak self] payment in
        self?.resignFirstResponder()
      }
      return paymentView
    }()
      
    override var inputView: UIView? {
      return paymentView
    }
}

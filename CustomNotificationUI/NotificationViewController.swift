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
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }

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
    }
 
}

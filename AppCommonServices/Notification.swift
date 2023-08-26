//
//  Notification.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 8/26/23.
//

import Foundation

extension Notification.Name {
    static let acceptButton = Notification.Name("acceptTapped")
    static let rejectButton = Notification.Name("rejectTapped")

    func post(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        center.post(name: self, object: object, userInfo: userInfo)
    }
    
    @discardableResult
    func onPost(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return center.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}

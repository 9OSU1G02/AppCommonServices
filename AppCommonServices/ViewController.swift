//
//  ViewController.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 8/25/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var accepted: UILabel!
    @IBOutlet private var rejected: UILabel!

    private var numAccepted = 0 {
        didSet {
            accepted.text = "\(numAccepted)"
        }
    }

    private var numRejected = 0 {
        didSet {
            self.rejected.text = "\(numRejected)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Notification.Name.acceptButton.onPost { [weak self] _ in
            self?.numAccepted += 1
        }
        Notification.Name.rejectButton.onPost { [weak self] _ in
            self?.numRejected += 1
        }
    }
}

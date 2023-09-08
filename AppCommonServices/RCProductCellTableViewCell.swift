//
//  RCProductCellTableViewCell.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 9/8/23.
//

import UIKit

class RCProductCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
        
    func setup(name: String, price: String, isPurchased: Bool) {
        nameLabel.text = name
        priceLabel.text = price
        stateImageView.image = .init(systemName: isPurchased ? "checkmark" : "xmark")
    }
}

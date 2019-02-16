//
//  PersonFoldingCell.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
import UIKit
class PersonFoldingCell: BaseCell {
    static let height: CGFloat = 300
    @IBOutlet weak var borderView: GradientBorderView! {
        didSet {
            borderView.cornerRadius = 10
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
}

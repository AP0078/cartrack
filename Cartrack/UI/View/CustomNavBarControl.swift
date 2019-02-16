//
//  CustomNavBarControl.swift
//  Cartrack
//
//  Created by Aung Phyoe on 15/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class CustomNavBarControl: UIView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    static func viewFromNib() -> CustomNavBarControl {
        return nib.instantiate(withOwner: nil, options: nil).first as! CustomNavBarControl
    }
    @IBOutlet weak var navigationBar: UIToolbar! {
        didSet {
            navigationBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
            navigationBar.setShadowImage(UIImage(), forToolbarPosition: .any)
            navigationBar.isTranslucent = true
            navigationBar.backgroundColor = .clear
        }
    }
    @IBOutlet weak var navigationBarTitle: UIBarButtonItem!
    @IBOutlet weak var navigationLeftButton: UIBarButtonItem!
    @IBOutlet weak var navigationRightButton: UIBarButtonItem!
}

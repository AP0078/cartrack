//
//  LoginViewController.swift
//  Cartrack
//
//  Created by Aung Phyoe on 15/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginIconOriginY: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageTop: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageBottom: NSLayoutConstraint!
    @IBOutlet weak var loginIconImageView: UIImageView!
    @IBOutlet weak var loginContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 2, delay: 1, options: [.curveEaseOut], animations: {
            self.loginIconOriginY.constant = 10
            self.backgroundImageTop.constant = -200
            self.backgroundImageBottom.constant = -200
            self.view.layoutIfNeeded()
        }) { (complete) in
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginContainerView.roundCorners([.topLeft, .topRight], radius: 10)
    }
}

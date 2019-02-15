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
    @IBOutlet weak var loginContainerBottom: NSLayoutConstraint! {
        didSet {
            loginContainerBottom.constant = -250
        }
    }
    @IBOutlet weak var loginIconImageView: UIImageView!
    @IBOutlet weak var loginContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.5, delay: 1, options: [.curveEaseOut], animations: {
            self.loginIconOriginY.constant = 10
            self.backgroundImageTop.constant = -200
            self.backgroundImageBottom.constant = -200
            self.loginContainerBottom.constant = 0
            self.view.layoutIfNeeded()
        }) { (complete) in
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginContainerView.roundCorners([.topLeft, .topRight], radius: 10)
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(truncating: curve)), animations: {
                    if UIDevice.current.orientation == .portrait {
                        self.loginContainerBottom.constant = keyboardSize.height
                    } else {
                        self.loginContainerBottom.constant = (keyboardSize.height - 70)
                    }
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(truncating: curve)), animations: {
                self.loginContainerBottom.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

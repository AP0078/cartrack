//
//  LoginViewController.swift
//  Cartrack
//
//  Created by Aung Phyoe on 15/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
import UIKit
import UnderLineTextField

class LoginViewController: UIViewController {
    @IBOutlet weak var loginIconOriginY: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageTop: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageBottom: NSLayoutConstraint!
    @IBOutlet weak var loginContainerBottom: NSLayoutConstraint! {
        didSet {
            loginContainerBottom.constant = -250
        }
    }
    var invalid: Bool = false
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(sender:)))
            backgroundImageView.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var usernameTextField: UnderLineTextField! {
        didSet {
            usernameTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UnderLineTextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var loginButton: PrimaryButton! {
        didSet {
            loginButton.isEnabled = false
        }
    }
    @IBOutlet weak var selectLocationLabel: UILabel! {
        didSet {
            selectLocationLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
            selectLocationLabel.addGestureRecognizer(tap)
            selectLocationLabel.attributedText = self.selectedCountry()
        }
    }
    @objc func handleImageTap(sender: UITapGestureRecognizer? ) {
        // handling code
        self.view.endEditing(true)
    }
    @objc func handleTap(sender: UITapGestureRecognizer? ) {
        // handling code
        //self.view.endEditing(true)
        countrySelectionList()
    }
    var countryList: [Country]?
    var username: String = ""
    var password: String = ""
    var countryName: String = ""
    func selectedCountry(_ country: Country? = nil) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "")
        if let country = country {
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: country.flag ?? "")
            attachment.bounds = CGRect(origin: CGPoint(x: 0, y: -13), size: attachment.image?.size ?? CGSize.zero)
            attributedText.append(NSAttributedString(attachment: attachment))
            attributedText.append(NSAttributedString(string: "   "))
            attributedText.append(NSAttributedString(string: country.name ?? ""))
            self.countryName =  country.name ?? ""
        } else {
            self.countryName = ""
             attributedText.append(NSAttributedString(string: "Select country"))
        }
        self.checkFormFilled()
        attributedText.append(NSAttributedString(string: " ⌄", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.baselineOffset: 2]))
        return attributedText
    }
    func checkFormFilled() {
        if !self.username.isEmpty, !self.password.isEmpty, !self.countryName.isEmpty {
            self.loginButton.isEnabled = true
            return
        }
        self.loginButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MockDataHelper.shared.fetchMockData { (complete) in
           self.countryList = MockDataHelper.shared.getCountryList()
        }
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1.5, delay: 1.5, options: [.curveEaseOut], animations: {
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
    func cleanLoginData() {
        username = ""
        password = ""
        countryName = ""
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
        self.selectLocationLabel.attributedText = selectedCountry()
    }
    @IBAction func loginAction(_ sender: Any) {
        self.view.endEditing(true)
        if MockDataHelper.shared.validateUser(name: self.username, password: self.password, location: self.countryName) {
            self.invalid = false
            self.cleanLoginData()
            self.performSegue(withIdentifier: "showpersonsegue", sender: nil)
        } else {
              self.invalid = true
            do {
                try self.usernameTextField.validate()
            } catch {
                print(error)
            }
            do {
                try self.passwordTextField.validate()
            } catch {
                print(error)
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: UIView.AnimationOptions.RawValue(truncating: curve)), animations: {
                    switch UIDevice.current.orientation {
                    case .landscapeLeft, .landscapeRight:
                         self.loginContainerBottom.constant = (keyboardSize.height - 70)
                    default:
                         self.loginContainerBottom.constant = keyboardSize.height
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
    func countrySelectionList() {
        let listVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryListViewController") as! CountryListViewController
        if let countries = self.countryList {
            listVC.countryList = countries
        }
        listVC.modalPresentationStyle = .overCurrentContext
        listVC.delegate = self
        self.present(listVC, animated: true, completion: nil)
    }
}
extension LoginViewController: CountrySelectionDelegate {
    func selectedCountry(_ country: Country, viewController: UIViewController) {
        self.selectLocationLabel.attributedText = self.selectedCountry(country)
        viewController.dismiss(animated: true, completion: nil)
    }
}
extension LoginViewController: UnderLineTextFieldDelegate {
    func textFieldValidate(underLineTextField: UnderLineTextField) throws {
        if invalid {
            throw UnderLineTextFieldErrors
                .error(message: "Username or password is incorrect")
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let completeText = String(format: "%@%@", textField.text ?? "", string)
        
        if textField == self.usernameTextField {
            username = completeText
        } else if textField == self.passwordTextField {
            password = completeText
        }
        self.checkFormFilled()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.invalid {
            self.invalid = false
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            do {
                try self.usernameTextField.validate()
            } catch {
                print(error)
            }
            do {
                try self.passwordTextField.validate()
            } catch {
                print(error)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == passwordTextField {
            textField.resignFirstResponder()
        } else {
           _ = passwordTextField.becomeFirstResponder()
        }
        return true
    }
}

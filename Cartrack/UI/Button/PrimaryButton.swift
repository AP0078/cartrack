//
//  PrimaryButton.swift
//  Cartrack
//
//  Created by Aung Phyoe on 15/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class PrimaryButton: UIButton {
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        return gradientLayer
    }()
    @IBInspectable
    var startColor: UIColor = #colorLiteral(red: 0.1725490196, green: 0.5254901961, blue: 0.9725490196, alpha: 1) {
        didSet {
            setGradient(startGradientColor: startColor, endGradientColor: endColor)
        }
    }
    @IBInspectable
    var endColor: UIColor = #colorLiteral(red: 0.1215686275, green: 0.431372549, blue: 0.8549019608, alpha: 1) {
        didSet {
            setGradient(startGradientColor: startColor, endGradientColor: endColor)
        }
    }
    @IBInspectable
    var highlightedStartColor: UIColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1)
    @IBInspectable
    var highlightedendColor: UIColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        if  gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        if isEnabled {
            self.layer.cornerRadius = 6
            self.layer.shadowColor = startColor.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 5.0
            setGradient(startGradientColor: startColor, endGradientColor: endColor)
        } else {
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.0
            self.layer.shadowRadius = 0.0
            setGradient(startGradientColor: UIColor.lightGray, endGradientColor: UIColor.lightGray)
        }
    }
    private func setGradient(startGradientColor: UIColor?, endGradientColor: UIColor?) {
        if let startGradientColor = startGradientColor, let endGradientColor = endGradientColor {
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [startGradientColor.cgColor, endGradientColor.cgColor]
            gradientLayer.borderColor = self.layer.borderColor
            gradientLayer.borderWidth = self.layer.borderWidth
            gradientLayer.cornerRadius = self.layer.cornerRadius
            self.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            if  gradientLayer.superlayer != nil {
                gradientLayer.removeFromSuperlayer()
            }
        }
    }
    override var isHighlighted: Bool {
        didSet {
            if  gradientLayer.superlayer != nil {
                gradientLayer.removeFromSuperlayer()
            }
            if isHighlighted {
                setGradient(startGradientColor: highlightedStartColor, endGradientColor: highlightedendColor)
            } else {
                setGradient(startGradientColor: startColor, endGradientColor: endColor)
            }
        }
    }
    override var isEnabled: Bool {
        didSet {
            setup()
        }
    }
    override var bounds: CGRect {
        didSet {
            setup()
        }
    }
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.setup()
        }
    }
}

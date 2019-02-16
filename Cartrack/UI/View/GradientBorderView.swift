//
//  GradientBorderView.swift
//  iCom
//
//  Created by Aung Phyoe on 10/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import UIKit

@IBDesignable
class GradientBorderView: UIView {
    @IBInspectable
    var startColor: UIColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1) {
        didSet {
             applyGardient()
        }
    }
    @IBInspectable
    var endColor: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) {
        didSet {
             applyGardient()
        }
    }
    @IBInspectable
    var borderWidth: CGFloat = 1.0 {
        didSet {
             applyGardient()
        }
    }
    @IBInspectable
    var cornerRadius: CGFloat = 5.0 {
        didSet {
            applyGardient()
        }
    }
    @IBInspectable
    var showShadow: Bool = false {
        didSet {
            applyGardient()
        }
    }
    var gradientBackgroundColor: UIColor = UIColor.white {
        didSet {
              applyGardient()
        }
    }
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        return gradientLayer
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        applyGardient()
    }
    override var bounds: CGRect {
        didSet {
            applyGardient()
        }
    }
    private func applyGardient() {
        self.backgroundColor = gradientBackgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        self.layer.shadowRadius = 4.0
        setGradient(startGradientColor: startColor, endGradientColor: endColor)
    }
    private func setGradient(startGradientColor: UIColor?, endGradientColor: UIColor?) {
        if let startGradientColor = startGradientColor, let endGradientColor = endGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = cornerRadius
            let mask = CAShapeLayer()
            mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            mask.fillColor = UIColor.clear.cgColor
            mask.strokeColor = UIColor.white.cgColor
            gradientLayer.colors = [startGradientColor.cgColor, endGradientColor.cgColor]
            self.layer.shadowOpacity = 0.2
            mask.lineWidth = borderWidth
            gradientLayer.mask = mask
            layer.addSublayer(gradientLayer)
        } else {
            if  gradientLayer.superlayer != nil {
                gradientLayer.removeFromSuperlayer()
            }
        }
    }
}

//
//  ViewExtension.swift
//  Cartrack
//
//  Created by Aung Phyoe on 15/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import UIKit
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        _ = self.getRoundCorners(corners, radius: radius)
    }
    func getRoundCorners(_ corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
}

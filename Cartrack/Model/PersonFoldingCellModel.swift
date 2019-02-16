//
//  PersonFoldingCellModel.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import UIKit
import MapKit
class PersonFoldingCellModel: NSObject {
    var title: String?
    var pin = MKPointAnnotation()
    var texts: [DynamicText] = []
    fileprivate var contentText: NSAttributedString?
    init(title: String? = nil, pin: MKPointAnnotation, texts: [DynamicText]) {
        self.title = title
        self.texts = texts
        self.pin = pin
    }
    var content: NSAttributedString {
        if let contentText = contentText {
            return contentText
        }
        let attribute = NSMutableAttributedString()
        for index in 0..<self.texts.count {
            let data = self.texts[index]
            if index == 0 {
                attribute.append(NSAttributedString(string: data.title,
                                                    attributes: [.font: data.font, .foregroundColor: data.color]))
            } else {
                attribute.append(NSAttributedString(string: String(format: "\n%@", data.title),
                                                    attributes: [.font: data.font, .foregroundColor: data.color]))
            }
        }
        contentText = attribute
        return attribute
    }
}

extension PersonFoldingCellModel {
    static func getAttibute(subtext: String, font: UIFont = UIFont.systemFont(ofSize: 13), color: UIColor = .darkGray) -> DynamicText {
        return DynamicText(title: subtext, font: font, color: color)
    }
    static func getAttibute(text: String, font: UIFont = UIFont.systemFont(ofSize: 14), color: UIColor = .black) -> DynamicText {
        return DynamicText(title: text, font: font, color: color)
    }
}
class DynamicText: NSObject {
    var title: String = ""
    var font: UIFont = UIFont.systemFont(ofSize: 13)
    var color: UIColor = .darkGray
    init(title: String, font: UIFont, color: UIColor) {
        self.title = title
        self.font = font
        self.color = color
    }
}

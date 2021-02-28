//
//  Extensions.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 28.12.2020.
//

import UIKit

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension UILabel {
    convenience init(text: String, font: UIFont, numberOfLines: Int = 1, textColor: UIColor = .label) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
        self.textColor = textColor
    }
}

//
//  Extensions.swift
//  Gems Game Testing
//
//  Created by vLinkD on 15/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView {
    func upperShowAnimation() {
        let center = self.center
        self.center.y = -bounds.height
        alpha = 0.0
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.center = center
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func downShowAnimation() {
        let center = self.center
        self.center.y = bounds.height + 100
        alpha = 0.0
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.center = center
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func upperHideAnimation() {
        let center = self.center
        alpha = 1.0
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.center = center
            self.center.y = -self.bounds.height
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func downHideAnimation() {
        let center = self.center
        alpha = 1.0
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.center = center
            self.center.y = self.bounds.height + 100
            self.alpha = 0.0
        }, completion: nil)
    }
}


class ConrnerView: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
    }
}

class CircleView: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = frame.height / 2
    }
}

class ConrnerButton: UIButton {
    override func awakeFromNib() {
        self.layer.cornerRadius = frame.height / 2
    }
}

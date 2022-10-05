//
//  GemView.swift
//  Gems Game Testing
//
//  Created by vLinkD on 15/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class GemView: UIView {
    static let colors: [UIColor] = [UIColor(rgb: 0x96BCF9), UIColor(rgb: 0xD66351), UIColor(rgb: 0xE6DE53), UIColor(rgb: 0xA1E59C)]
    //0asmani
    //1Red
    //2Yellow
    //lightGreen
    
    var loc = GemLoc()
    weak var board: BoardView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        isUserInteractionEnabled = false
      //  backgroundColor = GemView.colors[Int.random(in: 0..<GemView.colors.count)]
       // let tap = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        //addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
//    @objc func actionTap() {
//        var a = loc
//        a.y -= 1
//        var b = loc
//        b.y -= 2
//        board?.clearArr(locs: [loc])
//    }
 
    // add pulse
    let pulse = CAShapeLayer()
    func addPulse(fillColor: UIColor) {
        pulse.fillColor = fillColor.cgColor
        pulse.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0.1
        scaleAnimation.toValue = 2.0
        scaleAnimation.duration = 0.5
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = 0.5
        opacityAnimation.values = [alpha, alpha * 1, 0.0]
        opacityAnimation.fillMode = .forwards
        opacityAnimation.isRemovedOnCompletion = false
        //opacityAnimation.keyTimes = [0.0, NSNumber(value: keyTimeForHalfOpacity), 1.0]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = 1
        animationGroup.fillMode = .forwards
        animationGroup.isRemovedOnCompletion = false
        
        layer.addSublayer(pulse)
        pulse.frame = bounds
        pulse.add(animationGroup, forKey: "pulse")
    }
}

struct GemLoc {
    var x = -1, y = -1, color = 0
    
    init(){}
    
    init(_ x: Int, _ y: Int,_ color: Int) {
        self.x = x
        self.y = y
        self.color = color
    }
    
    func isNeigbour(loc: GemLoc) -> Bool {
        return ((loc.x - 1 == x || loc.x + 1 == x) && loc.y == y) ||
             ((loc.y - 1 == y || loc.y + 1 == y) && loc.x == x)
    }
    
    func isPairNeigbour(loc: GemLoc) -> Bool {
        return ((loc.x - 1 == x || loc.x + 1 == x) && loc.y == y) ||
            ((loc.y - 1 == y || loc.y + 1 == y) && loc.x == x)
    }
}



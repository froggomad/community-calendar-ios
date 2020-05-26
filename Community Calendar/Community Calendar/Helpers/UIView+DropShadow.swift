//
//  UIView+DropShadow.swift
//  Community Calendar
//
//  Created by Michael on 4/24/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

extension UIView {
    func blackShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func whiteShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func textShadow() {
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shouldRasterize = true
    }
    
    func contactShadow() {
        let shadowSize: CGFloat = 20
        let contactRect = CGRect(x: -shadowSize, y: bounds.height - (shadowSize * 0.4), width: bounds.width + shadowSize * 2, height: shadowSize)
        
        layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.45
    }
    
    func floatingContactShadow() {
        let shadowSize: CGFloat = 10
        let shadowDistance: CGFloat = 30
        let contactRect = CGRect(x: shadowSize, y: bounds.height - (shadowSize * 0.4) + shadowDistance, width: bounds.width - shadowSize * 2, height: shadowSize)
        layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
    }
    
    func depthShadow() {
        let shadowRadius: CGFloat = 5
        
        let shadowWidth: CGFloat = 1.25
        let shadowHeight: CGFloat = 0.5
        
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: shadowRadius / 2, y: bounds.height - shadowRadius / 2))
        shadowPath.addLine(to: CGPoint(x: bounds.width - shadowRadius / 2, y: bounds.height - shadowRadius / 2))
        shadowPath.addLine(to: CGPoint(x: bounds.width * shadowWidth, y: bounds.height + (bounds.height * shadowHeight)))
        shadowPath.addLine(to: CGPoint(x: bounds.width * -(shadowWidth - 1), y: bounds.height + (bounds.height * shadowHeight)))
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
    }
    
    func gradientShadow1(scale: Bool = true) {
        
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        
        layer.shadowOpacity = 0.9
        
        layer.shadowOffset = CGSize(width: 7, height: 5)
        
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
    
    func gradientShadow2(scale: Bool = true) {
        layer.masksToBounds = false
        
        layer.shadowColor = #colorLiteral(red: 0.7410163879, green: 0.4183317125, blue: 0.4147843719, alpha: 1)
        
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: -3, height: -5)
        
        layer.shadowRadius = 11
        
        layer.shouldRasterize = true
        
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func settingsShadow(scale: Bool = true) {
        
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        
        layer.shadowOpacity = 0.9
        
        layer.shadowOffset = CGSize(width: 12, height: 12)
        
        layer.shadowRadius = 7
        layer.shouldRasterize = true
        
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
    }
}

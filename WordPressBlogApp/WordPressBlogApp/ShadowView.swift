//
//  ShadowView.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 04/09/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation
import UIKit

class ShadowView: UIView {
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    fileprivate func setupShadow() {
        self.layer.shadowOffset = CGSize(width: 0.7, height: 0.7)
        self.layer.shadowRadius = 0.08
        self.layer.shadowOpacity = 0.15
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 0, height: 0)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

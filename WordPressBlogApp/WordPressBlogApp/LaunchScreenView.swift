//
//  LaunchScreenView.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 06/10/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit

class LaunchScreenView: UIView {
    
    //MARK: Properties
    
    override func draw(_ rect: CGRect) {
        SwiftPadawanLaunchScreenDesign.drawView(frame: self.bounds, resizing: .aspectFit)
    }
}

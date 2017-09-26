//
//  Helpers.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 09/09/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation
import UIKit

extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate(format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String, outputFormat:String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}

extension UIImageView {
    
    func makeRounded() {
        let radius = self.frame.size.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int, alpha: CGFloat) {
        let red = CGFloat(r)/255
        let green = CGFloat(g)/255
        let blue = CGFloat(b)/255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}





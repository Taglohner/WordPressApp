//
//  StatusBar.swift
//  WordPressBlogApp
//
//  Created by Steven Admin on 08/09/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

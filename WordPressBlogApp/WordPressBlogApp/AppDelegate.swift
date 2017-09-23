//
//  AppDelegate.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 29/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static let stack = CoreDataStack(modelName: "WordPressCoreDataModel")!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /* print SQL directory */
        AppDelegate.stack.applicationDocumentsDirectory()
        
        /* start autosaving */
        AppDelegate.stack.autoSave(60)
        
        return true
    }
    
}


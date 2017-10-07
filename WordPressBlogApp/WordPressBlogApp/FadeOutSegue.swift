//
//  FadeOutSegue.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 07/10/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit

class FadeOutSegue: UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    
    func scale() {
        let destinationViewController = self.destination
        let sourceViewController = self.source
//
//        let containerView = fromViewController.view.superview
//        let originalCenter = fromViewController.view.center
        
        destinationViewController.view.frame = UIScreen.main.bounds
        
//        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
//        toViewController.view.center = originalCenter
//        containerView?.addSubview(toViewController.view)
        
        destinationViewController.view.alpha = 0
        sourceViewController.view.addSubview(destinationViewController.view)
        
        UIView.animate(withDuration: 10, delay: 0, options: .curveEaseInOut, animations: {
            destinationViewController.view.alpha = 1
        }, completion: { success in
            destinationViewController.present(destinationViewController, animated: false, completion: nil)
        })
    }
    
}

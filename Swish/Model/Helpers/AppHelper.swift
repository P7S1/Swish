//
//  AppHelper.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/28/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit


class AppHelper {
    static let shared = AppHelper()
    
    static var appstoreID = "1513765135"
    
    func boldFont(of size : CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }
    
    func mediumFont(of size: CGFloat) -> UIFont{
        return UIFont(name: "AvenirNext-Medium", size: size)!
    }
    
    static func launchHomeScreen(vc : UIViewController, window : UIWindow){
        window.rootViewController = vc
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })
        
    }
    
}

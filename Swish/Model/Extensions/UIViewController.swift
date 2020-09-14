//
//  UIViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/29/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //headerView for tableViews
    func getHeaderView(with title : String, tableView : UITableView) -> UIView{
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
         
        headerView.backgroundColor = .clear

        let label = UILabel(frame: headerView.bounds)
        label.frame.origin.x = label.frame.origin.x + 8
        label.text = title
        label.font = AppHelper.shared.mediumFont(of: 13)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        
        headerView.addSubview(label)

         return headerView
    }
    
    func returnToLoginScreen(){
        userListener?.remove()
        userListener = nil
        User.shared = nil
        
        let alertController = UIAlertController(title: "Logged out", message: "You have been logged out, please log back in", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (alert) in
            let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            AppHelper.launchHomeScreen(vc: vc, window: keyWindow!)
        }))
        alertController.view.tintColor = .systemTeal
        self.present(alertController, animated: true, completion: nil)
    }
    
}

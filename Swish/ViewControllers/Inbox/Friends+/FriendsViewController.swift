//
//  FriendsViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/7/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import CarbonKit
class FriendsViewController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    let myFriendsViewController : MyFriendsViewController = {
        let storyboard = UIStoryboard(name: "Friends", bundle: nil)
        return storyboard.instantiateViewController(identifier: "MyFriendsViewController") as! MyFriendsViewController
    }()
    
    let addFriendsViewController : AddFriendsViewController = {
        let storyboard = UIStoryboard(name: "Friends", bundle: nil)
        return storyboard.instantiateViewController(identifier: "AddFriendsViewController") as! AddFriendsViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Friends"
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.view.backgroundColor = .systemBackground

        let items = ["MY FRIENDS", "ADD FRIENDS"]
        
        let carbonTabSwipeNavigation = CarbonSwipe(items: items, delegate: self)
        carbonTabSwipeNavigation.configure(items: items, vc: self)
        carbonTabSwipeNavigation.delegate = self
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            return myFriendsViewController
        default:
            return addFriendsViewController
        }
    }
    


}

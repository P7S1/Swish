//
//  TabBarController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/25/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.isTranslucent = false
        self.tabBar.itemPositioning = .centered
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        
        let playStoryboard = UIStoryboard(name: "Play", bundle: nil)
        let playVC = playStoryboard.instantiateViewController(identifier: "PlayViewController") as! PlayViewController
        playVC.tabBarItem = UITabBarItem(title: "PLAY", image: UIImage.init(systemName: "gamecontroller", withConfiguration: config), tag: 0)
        
        let inboxStoryboard = UIStoryboard(name: "Inbox", bundle: nil)
        let inboxVC = inboxStoryboard.instantiateViewController(identifier: "InboxViewController") as! InboxViewController
        inboxVC.tabBarItem = UITabBarItem(title: "INBOX", image: UIImage.init(systemName: "envelope", withConfiguration: config), tag: 0)

        
        self.viewControllers = [UINavigationController(rootViewController: inboxVC), UINavigationController(rootViewController: playVC)]
        
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

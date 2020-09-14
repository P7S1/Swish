//
//  AppDelegate.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/25/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import Firebase
import SCSDKLoginKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureNavBar()
        FirebaseApp.configure()
        configureProgressHUD()
        return true
    }
    
    // MARK: - Handle custom incoming url (typically when a user first installs the app)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("AppDelegate -> Received an url through a custom scheme: \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            MainDelegatesManager.handleIncomingDynamicLink(dynamicLink)
            return true
        } else {
            return SCSDKLoginClient.application(app, open: url, options: options)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationsHelper.shared.scheduleNotificationForPollExpirationDate()
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func configureProgressHUD(){
        window = UIWindow(frame: UIScreen.main.bounds)
        SVProgressHUD.setFont(AppHelper.shared.mediumFont(of: 17))
        SVProgressHUD.setBackgroundColor(.systemBackground)
        SVProgressHUD.setForegroundColor(.label)
    }
    
    func configureNavBar(){
      let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.shadowColor = .none
        navBarAppearance.largeTitleTextAttributes = [
            NSAttributedString.Key.font : AppHelper.shared.boldFont(of: 30),
            NSAttributedString.Key.foregroundColor : UIColor.label]
        navBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.font : AppHelper.shared.boldFont(of: 17),
            NSAttributedString.Key.foregroundColor : UIColor.label]
        navBarAppearance.backgroundEffect = .none
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = .label

        
        
        UITabBar.appearance().tintColor = .label
        UITabBar.appearance().backgroundColor = .systemBackground
        let attributes = [NSAttributedString.Key.font : AppHelper.shared.boldFont(of: 10) ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
    }


}


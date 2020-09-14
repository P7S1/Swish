//
//  SceneDelegate.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/25/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import FirebaseAuth
import Firebase
var userListener: ListenerRegistration?
let db = Firestore.firestore()
let notificationCenter = NotificationCenter.default
var functions = Functions.functions()
var ref = Database.database().reference()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var hasRanBefore = false
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        notificationCenter.addObserver(self, selector: #selector(logUserIn), name: NSNotification.Name(rawValue: "logUserIn"), object: nil)
        if Auth.auth().currentUser != nil && Auth.auth().currentUser?.phoneNumber != nil{
            self.logUserIn()
        }else{
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                window.rootViewController = UINavigationController(rootViewController: loginVC)
                self.window = window
                window.makeKeyAndVisible()
            }
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        NotificationsHelper.shared.scheduleNotificationForPollExpirationDate()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else {
           return
       }
        let urlString = context.url.absoluteString.replacingOccurrences(of: "swishapp", with: "swishApp", options: .literal)

        let url = URL(string: urlString)!
        SCSDKLoginClient.application( UIApplication.shared, open: url, options: nil)
        }
    
    @objc func logUserIn(){
        let uid = Auth.auth().currentUser!.uid
        hasRanBefore = false
        let userRef = db.collection("users").document(uid)
        userListener = userRef.addSnapshotListener({ (document, error) in
            if error == nil{
                if Auth.auth().currentUser?.phoneNumber != nil,
                document?.data() != nil{
                    if let user = User(data: document!.data()!){
                      User.shared = user
                      if !self.hasRanBefore{
                        AppHelper.launchHomeScreen(vc: TabBarController(), window: self.window!)
                        }
                    }
                }else{
                    //Document doesn't exist, take the user back to the login screen
                    self.hasRanBefore = true
                    self.presentNameVC()
                    userListener = nil
                }
                self.hasRanBefore = true        
            }else{
                print("there was an logging in error : \(error!.localizedDescription)")
            }
        })
    }
    
    func presentNameVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NameViewController") as! NameViewController
        AppHelper.launchHomeScreen(vc: UINavigationController(rootViewController: vc), window: window!)
        userListener = nil
    }

    
    // MARK: - Handel universal links
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
            if let incomingUrl = userActivity.webpageURL {
                print("SceneDelegate -> Incoming URL: \(incomingUrl)")
                let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl) { (dynamicLink, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        return
                    }
                    if let dynamicLink = dynamicLink {
                        MainDelegatesManager.handleIncomingDynamicLink(dynamicLink)
                    }
                }
                if linkHandled {
                    print("SceneDelegate -> Dynamic link handeled")
                } else {
                    // do other stuff with other type of incoming url
                }
            }
        }

}


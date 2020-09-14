//
//  MainDelegatesManager.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/6/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import Firebase


struct MainDelegatesManager {
    static func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("MainDelegatesManager -> Dynamic link object does not have url")
            return
        }
        let matchType = dynamicLink.matchType
        print("MainDelegatesManager -> Your incoming link parameter is: \(url.absoluteString)")
        print("MainDelegatesManager -> Match confidence: \(matchType.rawValue)")
        if matchType == .unique {
            print("MainDelegatesManager -> Match confidence is .unique. Continuing to handle dynamic link...")
            checkIfIsProfileLink(url: url)
            
        }
    }
    
    static func checkIfIsProfileLink(url : URL){
        if let uid = url.queryParameters?["uid"]{
            let docRef = db.collection("users").document(uid)
            docRef.getDocument { (document, error) in
                if error == nil{
                    if let user = User(data: document!.data() ?? [String : Any]()){
                        ProfileViewController.present(user: user, viewController: nil)
                    }
                }
            }
        }
    }
    
    static func checkIfIsRefferalLink(url : URL){
        if let uid = url.queryParameters?["referralId"]{
            UserDefaults.standard.set(uid, forKey: "referralId")
        }
    }
}

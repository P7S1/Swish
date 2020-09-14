//
//  SnapchatHelper.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/04/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import SCSDKCreativeKit
import SCSDKLoginKit
import FirebaseFunctions
import Kingfisher

class SnapchatHelper{
    
    static var snapAPI: SCSDKSnapAPI = SCSDKSnapAPI()
    
    static func prepareSnap(stickerImage : UIImage){
        let sticker = SCSDKSnapSticker(stickerImage: stickerImage)
    
        let snap = SCSDKNoSnapContent()
        snap.sticker = sticker /* Optional */
        snap.attachmentUrl = "https://itunes.apple.com/app/id\(AppHelper.appstoreID)" /* Optional */
        
        shareSnap(content: snap, completionHandler: nil)
    }
    
    static func shareSnap(content : SCSDKSnapContent,completionHandler: ((Bool, Error?) ->())?) {
      snapAPI.startSending(content) { (error: Error?) in
        
        if error == nil{
            print("snap successful")
        }else{
            print("error \(error!.localizedDescription)")
        }
      }
    }
    
    static func retrieveFirebaseAuthToken( completion : @escaping (_ authToken : String, _ bitmojiURL : String?, _ externalId : String) -> Void){
        functions.httpsCallable("logInWithSnapchat").call([
            "accessToken": SCSDKLoginClient.getAccessToken()]) { (result, error) in
          if let error = error as NSError? {
            print("there was a token error : \(error.localizedDescription)")
          }
                let results = (result?.data as? [String: Any])
            
                if let authToken = results?["authToken"] as? String,
                    let externalId = results?["externalId"] as? String{
                    let photoURL = (results?["bitmojiURL"] as? String) ?? ""
                    completion(authToken, photoURL, externalId)
                }
        }
        
    }
    
}

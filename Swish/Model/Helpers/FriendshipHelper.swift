//
//  FriendshipHelper.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/7/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import Firebase

struct FriendshipHelper {
    
    static func getFriendShipId(uid : String, uid2 : String) -> String {
        if uid > uid2{
            return "\(uid)_\(uid2)"
        }else{
            return "\(uid2)_\(uid)"
        }
    }
    
    static func getRecommendedUsers(completion : @escaping ([GenericUser]) -> Void){
        functions.httpsCallable("getRecommendedUsers").call([]) { (result, error) in
            if let err = error{
                print("getting reccomended friends error : \(err.localizedDescription)")
            }
 
            if let payload = result?.data as? [String : Any], let resposne = RecommendedUserResponse(data: payload){
                var users = [GenericUser]()
                for user in resposne.userData{
                    if !users.contains(user) && !User.shared!.friends.contains(user.uid){
                        users.append(user)
                    }
                }
                
                completion(users)
            }
           
        }
    }
    
}

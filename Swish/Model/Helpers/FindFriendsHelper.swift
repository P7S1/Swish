//
//  FindFriendsHelper.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/6/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import Firebase

struct FindFriendsHelper{
    
    static func getUserIDsWithPhoneNumber(phoneNumbers : [String], completion : @escaping ([FirebaseContactResponse]) -> Void){
         
        functions.httpsCallable("getUserIDsWithPhoneNumber").call(["phoneNumbers":phoneNumbers]) { (result, error) in
             if let err = error{
                 print("getting polls error : \(err.localizedDescription)")
             }
            
            if let output = result?.data as? [String : Any],
                let results = output["results"] as? [[String:Any]]{
                
                var responses = [FirebaseContactResponse]()
                
                for data in results{
                    if let resposne = FirebaseContactResponse(data: data){
                        responses.append(resposne)
                    }
                }
                 completion(responses)
            }

             
             

         }
         
     }
    
    static func storeContactsOnDatabase(phoneNumbers : [String]) {
        let uid = Auth.auth().currentUser!.uid
        let docRef = db.collection("contacts").document(uid)
        docRef.setData(["contacts":phoneNumbers, "uid" : uid])
    }
    
}

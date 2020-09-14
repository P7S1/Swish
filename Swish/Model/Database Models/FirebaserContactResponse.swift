//
//  FirebaserContactResponse.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/6/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation

struct FirebaseContactResponse : Codable {
    let uid : String
    let phoneNumber : String
}


extension FirebaseContactResponse : Comparable{
    
    static func < (lhs: FirebaseContactResponse, rhs: FirebaseContactResponse) -> Bool {
        return lhs.phoneNumber < rhs.phoneNumber
    }
    
    static func == (lhs: FirebaseContactResponse, rhs: FirebaseContactResponse) -> Bool {
        return lhs.phoneNumber == rhs.phoneNumber
    }
    
}

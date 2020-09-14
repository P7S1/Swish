//
//  Friendship.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/7/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation

struct Friendship: Codable {
    
    var id1 : String
    var id2 : String
    var members : [String]
    var id : String
    var creatorName : String
    var receiverId : String
    
    init(followed : String) {
        if followed > User.shared!.uid{
            id1 = followed
            id2 = User.shared!.uid
            self.id = "\(followed)_\(User.shared!.uid)"
        }else{
            id1 = User.shared!.uid
            id2 = followed
            self.id = "\(User.shared!.uid)_\(followed)"
        }
        self.creatorName = User.shared!.getFullName()
        self.receiverId = followed
        self.members = [followed, User.shared!.uid]
    }
    
    
}

    

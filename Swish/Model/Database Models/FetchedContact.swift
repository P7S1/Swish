//
//  FetchedContact.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/6/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import Contacts

struct FetchedContact: Comparable {
    
    var firstName: String
    var lastName: String
    var telephone: String
    
    static func < (lhs: FetchedContact, rhs: FetchedContact) -> Bool {
        return lhs.firstName < rhs.lastName
    }
}

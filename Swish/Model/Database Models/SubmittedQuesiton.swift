//
//  SubmittedQuesiton.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/13/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation

struct SubmittedQuesiton : Codable {
    let questionText : String
    let photoURL : URL
    let isApproved : Bool
    let id : String
}

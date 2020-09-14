//
//  CompletedPollQuestion.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/30/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation

class CompletedPollQuestion : Codable, AnyPollQuestion {
    
    let members : [User]
    let questionText : String
    let photoURL : URL
    let id : String
    let chosenUser : User
    let gender: GenderType
    let index : String
    var hasBeenRevealed : Bool?
    init(question : PollQuestion, chosenUser : User) {
        
        self.members = question.members
        self.questionText = question.questionText
        self.photoURL = question.photoURL
        self.id = question.id
        self.gender = question.gender
        self.chosenUser = chosenUser
        self.index = question.index
        self.hasBeenRevealed = false
    }
    
}

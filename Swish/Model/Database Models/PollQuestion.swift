//
//  PollQuestion.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/30/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation

protocol AnyPollQuestion {
     var members : [User] { get }
     var questionText : String { get }
     var photoURL : URL { get }
     var id : String { get }
     var gender : GenderType { get }
     var index : String { get }
}



struct PollQuestion : Codable, AnyPollQuestion {

    let members : [User]
    let questionText : String
    let photoURL : URL
    let id : String
    let gender: GenderType
    let index : String
    
    init(response : PollQuestionResponse) {
        
        self.members = response.userData
        self.questionText = response.questionData.questionText
        self.photoURL = response.questionData.photoURL
        self.id = response.questionData.id
        self.gender = response.gender
        self.index = response.questionData.index
        
    }
    
}
/*
extension PollQuestion {
    
    static func < (lhs: PollQuestion, rhs: PollQuestion) -> Bool {
        return lhs.id < rhs.id
    }
    static func == (lhs: PollQuestion, rhs: PollQuestion) -> Bool {
        return lhs.id == rhs.id
    }
    
}
*/

//
//  InboxItem.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/2/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import DeepDiff
struct InboxItem : Codable {
    
    let question : CompletedPollQuestion
    
    let emojiID : Int
    let grade : GradeType
    let gender : GenderType
    let schoolLevel : SchoolLevelType
    let creationDate : Timestamp
    let id : String
    var hasBeenOpened : Bool
    let documentID: String
    let revealedUser : User?
    
    init(question : CompletedPollQuestion, documentID : String) {
        self.question = question
        
        self.grade = User.shared!.grade
        self.gender = User.shared!.gender
        self.schoolLevel = User.shared!.schoolLevel
        
        self.creationDate = Timestamp(date: Date())
        self.id = question.id
        self.emojiID = Int.random(in: 0...33)
        self.hasBeenOpened = false
        self.documentID = documentID
        self.revealedUser = nil
    }

    
    func getColor() -> UIColor{
        if gender == .male{
            return .systemTeal
        }else{
            return .systemPink
        }
    }
    
    
}

extension InboxItem : DiffAware{
    var diffId: UUID? {
        let id = UUID(uuidString: self.id)
        return id
    }
    
    typealias DiffId = UUID?
    

    static func compareContent(_ a: InboxItem, _ b: InboxItem) -> Bool {
        return (a.id == b.id && a.revealedUser == b.revealedUser)
        
    }
    
}

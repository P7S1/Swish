//
//  User.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/27/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AnyUser {
    var uid : String { get }
    var schoolID : String { get }
    var schoolName : String { get }
    var firstName : String { get }
    var lastName : String { get }
    var schoolLevel : SchoolLevelType { get }
    var grade : GradeType { get }
    var gender : GenderType { get }
    var bitmojiURL : URL? { get }
    var points : Int { get }
    var version : Int { get }
    var refferralId : String? { get }
    var friends : [String] { get }
    var tags : [String] { get }
    var random : Int { get }
    func getFullName() -> String
}

struct GenericUser : Codable, AnyUser{
    var uid: String
    
    var schoolID: String
    
    var schoolName: String
    
    var firstName: String
    
    var lastName: String
    
    var schoolLevel: SchoolLevelType
    
    var grade: GradeType
    
    var gender: GenderType
    
    var bitmojiURL: URL?
    
    var points: Int
    
    var version: Int
    
    var refferralId: String?
    
    var friends: [String]
    
    var tags: [String]
    
    var random: Int
    
    func getFullName() -> String{
        return "\(firstName) \(lastName)"
    }
    
}

extension GenericUser : Comparable{
    
    static func < (lhs: GenericUser, rhs: GenericUser) -> Bool {
        return lhs.uid < rhs.uid
    }
    
    static func == (lhs: GenericUser, rhs: GenericUser) -> Bool {
        return lhs.uid == rhs.uid
    }
    
}

struct User : Codable, AnyUser {
    
    typealias Value = AnyUser

    static var shared : User?
    
    let uid : String
    let schoolID : String
    let schoolName : String
    let firstName : String
    let lastName : String
    let schoolLevel : SchoolLevelType
    let grade : GradeType
    let gender : GenderType
    let bitmojiURL : URL?
    let creationDate : Timestamp
    let lastPollRequestDate : Timestamp
    let points : Int
    let version : Int
    let refferralId : String?
    var friends : [String]
    let tags : [String]
    var random: Int
    let ghostMode : Bool
    let externalId : String
    
    init() {
        let defaults = UserDefaults.standard
            
        self.uid = Auth.auth().currentUser!.uid
        self.schoolID = (defaults.value(forKey: "schoolID") as? String) ?? ""
        self.schoolName = (defaults.value(forKey: "schoolName") as? String) ?? ""
        self.firstName = defaults.value(forKey: "firstName") as! String
        self.lastName = defaults.value(forKey: "lastName") as! String
        self.schoolLevel = SchoolLevelType(rawValue: defaults.value(forKey: "schoolLevel") as! String)!
        self.grade = GradeType(rawValue: defaults.value(forKey: "grade") as! String)!
        self.gender = GenderType(rawValue: defaults.value(forKey: "gender") as! String)!
        self.bitmojiURL = Auth.auth().currentUser!.photoURL
        self.creationDate = Timestamp(date: Date())
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: -60, to: Date())
        self.lastPollRequestDate = Timestamp(date: date!)
        self.points = 0
        self.version = 0
        self.refferralId = defaults.value(forKey: "referralId") as? String
        self.friends = [String]()
        self.tags = [schoolID]
        self.random = Int.random(in: 0...4294967295)
        self.ghostMode = false
        self.externalId = defaults.value(forKey: "externalId") as? String ?? ""
    }
    
    func getFullName() -> String{
        return "\(firstName) \(lastName)"
    }
    
    func getPollExpirationDate() -> Date{
        let startDate = self.lastPollRequestDate.dateValue()
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: 60, to: startDate)
        return date ?? Date()
    }
    
    
}

extension User : Comparable{
    
    static func < (lhs: User, rhs: User) -> Bool {
        return lhs.uid < rhs.uid
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
    
}

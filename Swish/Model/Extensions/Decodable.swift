//
//  Decodable.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/30/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
extension Decodable {
  /// Initialize from data. Return nil on failure
     init?(data value: [String:Any]){
        do {
            let newValue = try Firestore.Decoder().decode(Self.self, from: value)
            self = newValue
        } catch _ {
            return nil
        }
      
    }
}
 

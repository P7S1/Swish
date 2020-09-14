//
//  Encodable.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/30/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Encodable {
  /// Returns a JSON dictionary
  func getDictionary() -> [String: Any]? {

    guard let data = try? Firestore.Encoder().encode(self) else { return nil }
    
    return data
  }
}


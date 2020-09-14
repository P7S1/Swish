//
//  GenderType.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/1/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

enum GenderType : String, Codable {

    case male = "male"
    case female = "female"
    case nonBinary = "non-binary"
    
    func getColor() -> UIColor{
        if self == .male{
            return UIColor.systemTeal
        }else if self == .female{
            return UIColor.systemPink
        }else{
            return UIColor.systemPurple
        }
    }
    
}

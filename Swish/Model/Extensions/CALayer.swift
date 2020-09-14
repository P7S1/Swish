//
//  CALayer.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/25/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit


extension CALayer {
    func addShadow(){
        shadowColor = UIColor.gray.cgColor
        shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowRadius = 10.0
        shadowOpacity = 0.5
    }
}

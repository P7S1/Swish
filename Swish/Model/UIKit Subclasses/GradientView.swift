//
//  GradientView.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 7/2/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

@IBDesignable
 class GradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    
    var gradient: CAGradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        createGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createGradient()
    }
    
    private func createGradient(){
        gradient.frame = bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
}

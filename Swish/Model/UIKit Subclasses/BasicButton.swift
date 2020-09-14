//
//  BasicButton.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/27/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class BasicButton: UIButton {
    
    let coverLayer : CALayer = {
        let coverLayer = CALayer()
        coverLayer.backgroundColor = UIColor.black.cgColor
        coverLayer.opacity = 0.0
        return coverLayer
        
    }()
    
    let selection = UISelectionFeedbackGenerator()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height * 0.35
        self.layer.addSublayer(coverLayer)
    }
    
    func addShadows(){
        self.layer.masksToBounds = false
        self.layer.addShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.coverLayer.masksToBounds = true
        self.coverLayer.cornerRadius = self.coverLayer.frame.height * 0.35
        self.coverLayer.frame = self.bounds
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       super.touchesBegan(touches, with: event)
        selection.selectionChanged()
        growButton()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       super.touchesEnded(touches, with: event)
        revertToNormal()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        revertToNormal()
    }
    
    func growButton(){
      DispatchQueue.main.async {
            // when tapped
            self.coverLayer.opacity = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
                self.coverLayer.opacity = 0.3
                self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }, completion: nil)
            
        }
    }
    
    func revertToNormal(){
       DispatchQueue.main.async {
        self.coverLayer.opacity = 0.4
            UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
                self.coverLayer.opacity = 0.0
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}

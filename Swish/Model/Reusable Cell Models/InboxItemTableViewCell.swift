//
//  InboxItemTableViewCell.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/3/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class InboxItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var emojiImageVIew: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    func setUpCell(item : InboxItem){
        
        indicatorView.layer.cornerRadius = indicatorView.frame.height/2
        
        timeLabel.text = item.creationDate.dateValue().getElapsedInterval()
        
        if item.hasBeenOpened{
            indicatorView.isHidden = true
            timeLabel.textColor = .secondaryLabel
        }else{
            indicatorView.isHidden = false
            timeLabel.textColor = .label
        }
        
        if let user =  item.revealedUser{
            emojiImageVIew.kf.setImage(with: user.bitmojiURL)
            hintLabel.text = user.getFullName()
        }else{
            var compositeText = ""
            
            if item.gender == .male{
                compositeText = "From a guy"
                
            }else if item.gender == .female{
                compositeText = "From a girl"
            }else{
                compositeText = "From someone"
            }
            
            var secondPart = ""
            switch item.grade {
            case .freshman:
                secondPart = " in the freshman class"
            case .sophomore:
                secondPart = " in the sophomore class"
            case .junior:
                secondPart = " in the junior class"
            case .senior:
                secondPart = " in the senior class"
            case .firstYear:
                secondPart = " in their first year of college"
            case .secondYear:
                secondPart = " in their second year of college"
            case .thirdYear:
                secondPart = " in their third year of college"
            case .fourthYear:
                secondPart = " in their fourth year of college"
            default:
                secondPart = ""
            }
            
            compositeText = "\(compositeText)\(secondPart)"
            
            hintLabel.text = compositeText

            emojiImageVIew.image = UIImage(named: "emoji_\(item.emojiID)")
        }
        hintLabel.textColor = item.getColor()
        
    }
    


}

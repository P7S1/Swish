//
//  MyFriendCollectionViewCell.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/7/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class MyFriendCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bitmojiImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var tapToViewLabel: UILabel!
    
    func setUpCell(user : AnyUser){
        bitmojiImageView.kf.setImage(with: user.bitmojiURL)
        nameLabel.text = user.getFullName()
        pointsLabel.text = "\(user.points) Points"
        
        contentView.layer.cornerRadius = contentView.frame.height * 0.05
        contentView.backgroundColor = .secondarySystemBackground
        
        if user.gender == .male{
            tapToViewLabel.textColor = .systemTeal
        }else if user.gender == .female{
            tapToViewLabel.textColor = .systemPink
        }else{
            tapToViewLabel.textColor = .systemPurple
        }
    }
}

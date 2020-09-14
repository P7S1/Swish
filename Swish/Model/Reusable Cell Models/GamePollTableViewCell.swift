//
//  GamePollTableViewCell.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/30/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class GamePollTableViewCell: UITableViewCell {

    @IBOutlet weak var bitmojiView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var pointingEmojiLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .systemBackground
        self.nameLabel.textColor = .label
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.2) {
            if selected{
                    self.backgroundColor = .systemGreen
                    self.nameLabel.textColor = .white
                    self.pointingEmojiLabel.isHidden = false
                
            }else{
                self.backgroundColor = .systemBackground
                self.nameLabel.textColor = .label
                self.pointingEmojiLabel.isHidden = true
            }
        }
        // Configure the view for the selected state
    }

}

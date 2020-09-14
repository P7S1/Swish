//
//  InviteFriendsTableViewCell.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/6/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class InviteFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usesSwishLabel: UILabel!
    @IBOutlet weak var inviteButton: BasicButton!
    
    var inviteButtonAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func inviteButtonPressed(_ sender: Any) {
        inviteButtonAction?()
    }
    
}

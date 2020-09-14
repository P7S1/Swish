//
//  SchoolLocationTableViewCell.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/28/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class SchoolLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

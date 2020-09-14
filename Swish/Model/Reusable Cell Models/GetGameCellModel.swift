//
//  GetGameCellModel.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/1/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import VerticalCardSwiper
class GetGameCellModel : CardCell {
    
    @IBOutlet weak var checkBackLabel: UILabel!
    
    var timer : Timer?
    
    @IBOutlet weak var emojiImageView: UIImageView!
    var delegate : PollAvaliablityDelegate?
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var bottomLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        startTimer()
        
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 25
        super.layoutSubviews()
    }
    
    func startTimer(){
       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func update(){
        if let user = User.shared{
            let date = user.getPollExpirationDate()
            let timeInterval = Date().distance(to: date)
            
            if User.shared!.ghostMode{
                delegate?.updateInviteFriendsButton(pollsAvaliable: false)
                emojiImageView.image = UIImage(named: "robot")
                checkBackLabel.text = "Go to Settings and turn off Ghost Mode to play Swish"
                bottomLabel.isHidden = true
                topLabel.isHidden = true
            }else if User.shared!.friends.count < 1{
                delegate?.updateInviteFriendsButton(pollsAvaliable: false)
                emojiImageView.image = UIImage(named: "waving")
                checkBackLabel.text = "You need atleast 1 friend to play Swish"
                bottomLabel.isHidden = true
                topLabel.isHidden = true
            }else {
                if timeInterval < 0{
                    delegate?.updateInviteFriendsButton(pollsAvaliable: true)
                    emojiImageView.image = UIImage(named: "rock")
                    checkBackLabel.text = "You're ready to play Swish!"
                    bottomLabel.isHidden = true
                    topLabel.isHidden = true
                }else{
                    delegate?.updateInviteFriendsButton(pollsAvaliable: false)
                    emojiImageView.image = UIImage(named: "ghost")
                    checkBackLabel.text = "Check back in \(stringFromTimeInterval(interval: timeInterval))"
                    bottomLabel.isHidden = false
                    topLabel.isHidden = false
                }
            }
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {

      let ti = NSInteger(interval)

      let seconds = ti % 60
      let minutes = (ti / 60) % 60

      return NSString(format: "%0.2dm %0.2ds",minutes,seconds)
    }
}

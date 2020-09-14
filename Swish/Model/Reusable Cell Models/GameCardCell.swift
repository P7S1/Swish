//
//  GameCardCell.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/29/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import UIKit
import VerticalCardSwiper
import Kingfisher
import AudioToolbox.AudioServices

class GameCardCell: CardCell {
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: AnimatedImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var shuffleButton: BasicButton!
    
    
    var poll : AnyPollQuestion?
    
    var delegate : PollChoiceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "GamePollCell", bundle: nil), forCellReuseIdentifier: "GamePollCell")
        
        tableView.layer.cornerRadius = tableView.frame.height * 0.1
        
        imageView.layer.cornerRadius = imageView.frame.height * 0.025
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.systemBackground.cgColor
    }
    
    
    @IBAction func shuffleButtonPressed(_ sender: Any) {
        shuffleButton.rotate()
        shuffleButton.isEnabled = false
        if let oldPoll = self.poll, let index = Int(oldPoll.index){
            PollHelper.skipQuestion(index: index) { (newPollQuestion) in
                self.delegate?.didReloadItem(item: newPollQuestion)
                self.shuffleButton.isEnabled = true
                self.shuffleButton.stopRotating()
                self.shake()
                self.setUp(poll: newPollQuestion)
            }
        }
    }
    
    func setUp(poll : AnyPollQuestion){
        self.poll = poll
        self.tableView.reloadData()
        self.imageView.kf.setImage(with: poll.photoURL)
        self.questionLabel.text = poll.questionText.uppercased()
        self.gradientView.layer.sublayers?.remove(at: 0)
        if poll.gender == .male{
            gradientView.startColor = UIColor.systemTeal
            gradientView.endColor = UIColor.systemBlue
        }else{
            gradientView.startColor = UIColor(red: 255/255, green: 101/255, blue: 91/255, alpha: 1)
            gradientView.endColor = UIColor.systemPink
        }
        
        if let _ = poll as? PollQuestion{
            self.isUserInteractionEnabled = true
            guard let indexPaths = tableView.indexPathsForSelectedRows else { return }
            for indexPath in indexPaths{
                tableView.deselectRow(at: indexPath, animated: true)
            }
            self.shuffleButton.isEnabled = true
            self.shuffleButton.isHidden = false
        }else if let poll = poll as? CompletedPollQuestion{
            self.isUserInteractionEnabled = false
            self.shuffleButton.isEnabled = false
            self.shuffleButton.isHidden = true
            guard let index = poll.members.firstIndex(of: poll.chosenUser) else { return }
            let indexPath = IndexPath(item: index, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }

    }

    override func layoutSubviews() {
        self.layer.cornerRadius = 25
        super.layoutSubviews()
    }

}

extension GameCardCell : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poll?.members.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.shuffleButton.isEnabled = false
        self.shuffleButton.isHidden = true
        
        if !(self.poll is CompletedPollQuestion){
            let poll = self.poll as! PollQuestion
            let user = poll.members[indexPath.row]
            let item = CompletedPollQuestion(question: poll, chosenUser: user)
            self.isUserInteractionEnabled = false
            
            // 'Peek' feedback (weak boom)
            let peek = SystemSoundID(1519)
            AudioServicesPlaySystemSound(peek)
            
            delegate?.didChooseItem(item: item)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamePollCell", for: indexPath) as! GamePollTableViewCell
        
        let user = poll?.members[indexPath.row]
        
        cell.bitmojiView.kf.setImage(with: user?.bitmojiURL)
        cell.nameLabel.text = user?.getFullName()
        
        return cell
    }
    
    
}

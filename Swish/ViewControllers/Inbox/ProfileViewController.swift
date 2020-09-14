//
//  ProfileViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/4/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import SwiftEntryKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var snapchatButton: BasicButton!
    @IBOutlet weak var followButton: BasicButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    var user : AnyUser!
    
    var isCurrentUser : Bool!
    @IBOutlet weak var shareButton: BasicButton!
    
    var vc : UIViewController?
    
    @IBOutlet weak var attributionStackView: UIStackView!
    @IBOutlet weak var slideUpImage: UIImageView!
    @IBOutlet weak var slideUpText: UILabel!
    
    @IBOutlet weak var profileView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.kf.setImage(with: user.bitmojiURL)
        backgroundView.layer.cornerRadius = 20
        nameLabel.text = user.getFullName()
        pointsLabel.text = "\(user.points) Points"
        schoolLabel.text = "\(user.schoolName)"
        
        isCurrentUser = User.shared!.uid == user.uid
        
        pointsLabel.textColor = user.gender.getColor()
        followButton.backgroundColor = user.gender.getColor()
        shareButton.tintColor = user.gender.getColor()
        slideUpText.textColor = user.gender.getColor()
        slideUpImage.tintColor = user.gender.getColor()
        
        if isCurrentUser{
            followButton.backgroundColor = .secondarySystemBackground
            followButton.setTitle("SETTINGS", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
        }else{
            if User.shared!.friends.contains(user.uid){
                setButtonAsFriendsState()
            }else{
                setButtonNotAsFreindsState()
            }
        }
        attributionStackView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func setButtonAsFriendsState(){
        followButton.backgroundColor = .secondarySystemBackground
        followButton.setTitleColor(user.gender.getColor(), for: .normal)
        followButton.setTitle("ADDED", for: .normal)
    }
    
    func setButtonNotAsFreindsState(){
        followButton.backgroundColor = user.gender.getColor()
        followButton.setTitleColor(.white, for: .normal)
        followButton.setTitle("ADD FRIEND", for: .normal)
    }
    
    static func present(user : AnyUser, viewController : UIViewController?){
        let storyboard = UIStoryboard(name: "Inbox", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        vc.user = user
        vc.vc = viewController
        SwiftEntryKit.display(entry: vc, using: getAttributes())
    }
    
    static func getAttributes() -> EKAttributes{
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .visualEffect(style: .extra)
        attributes.hapticFeedbackType = .success
        attributes.positionConstraints = .float
        attributes.positionConstraints.size.height = .constant(value: 300)
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        
        return attributes
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        if isCurrentUser{
            SwiftEntryKit.dismiss()
            let vc = storyboard?.instantiateViewController(identifier: "SettingsTableViewController") as! SettingsTableViewController
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        }else{
            let friend = Friendship(followed: user.uid)
            let docRef = db.collection("friends").document(friend.id)
            
            if User.shared!.friends.contains(user.uid){
                docRef.delete()
                User.shared!.friends.removeAll { (uid) -> Bool in
                    user.uid == uid
                }
                setButtonNotAsFreindsState()
            }else{
                if let data = friend.getDictionary(){
                    docRef.setData(data) { (error) in
                        if let err = error{
                            print(err.localizedDescription)
                        }
                    }
                }
                User.shared!.friends.append(user.uid)
                setButtonAsFriendsState()
            }
        }
    }
    
    @IBAction func snapchatButtonPressed(_ sender: Any) {
        self.attributionStackView.isHidden = false
        let image = self.profileView.asImage()
        SnapchatHelper.prepareSnap(stickerImage: image)
        self.attributionStackView.isHidden = true
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let uid = user.uid 
        let link = URL(string: "https://playswish.com/users/?uid=\(uid)")
        let referralLink = DynamicLinkComponents(link: link!, domainURIPrefix: "https://playswish.com/users")
 
        referralLink?.shorten { (shortURL, warnings, error) in
          if let error = error {
            print(error.localizedDescription)
            return
          }
            self.showShareDialog(text: shortURL?.absoluteString ?? "")
        }
    }
    
    func showShareDialog(text : String){
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.shareButton // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

//
//  PlayViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/25/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import VerticalCardSwiper
import FirebaseFirestore
import FirebaseFirestoreSwift
import SVProgressHUD
import SPPermissions
protocol PollChoiceDelegate {
    func didChooseItem(item : CompletedPollQuestion)
    func didReloadItem(item : AnyPollQuestion)
}

protocol PollAvaliablityDelegate {
    func updateInviteFriendsButton(pollsAvaliable : Bool)
}

class PlayViewController: HomeViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var cardSwiper : VerticalCardSwiper!
    
    var items = [AnyPollQuestion]()
    
    var extraIndex = 0
    
    var pollsAvaliable = false
    
    @IBOutlet weak var inviteFriendsButton: BasicButton!
    
    @IBOutlet weak var findFriendsButton: BasicButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(title: "Play")
        // Do any additional setup after loading the view.
        cardSwiper.register(nib: UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
        cardSwiper.register(nib: UINib(nibName: "GetGameCell", bundle: nil), forCellWithReuseIdentifier: "GetGameCell")
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        self.cardSwiper.activityIndicator(show: true)
        retrievePolls()
        setUpGestureRecognizers()
        updateInviteButton()
        inviteFriendsButton.addShadows()
        findFriendsButton.addShadows()
    }
    
    func setUpGestureRecognizers(){
        //fixes bug where gesture whithin the cell's tableview wouldn't be recognized
        if let gestures = cardSwiper.verticalCardSwiperView.gestureRecognizers{
            for gesture in gestures{
                if gesture is UITapGestureRecognizer{
                gesture.cancelsTouchesInView = false
                }
    
            }
            
        }

    }
    @IBAction func findFriendsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Friends", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddFriendsViewController") as! AddFriendsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func inviteAFriendPressed(_ sender: Any) {
        if items.count > 0 && cardSwiper.focussedCardIndex != items.count{
            if items[cardSwiper.focussedCardIndex ?? 0] is CompletedPollQuestion &&
                !((items[cardSwiper.focussedCardIndex ?? 0] as? CompletedPollQuestion)?.hasBeenRevealed ?? false){
                revealYourself()
            }else{
                getPollsOrInvite()
            }
        }else{
            getPollsOrInvite()
        }
    }
    func getPollsOrInvite(){
        if pollsAvaliable && User.shared!.friends.count >= 1{
            getPolls()
        }else{
            if SPPermission.contacts.isAuthorized{
                presentInviteVC()
            }else{
                showContactsDialog()
            }
        }
    }
    func revealYourself(){
        let alertVC = UIAlertController(title: "Reveal yourself?", message: "Are you sure you want to reveal your identity for this question?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }))
        alertVC.addAction(UIAlertAction(title: "I'm Sure", style: .default, handler: { (action) in
            if self.items.count > 0 && self.cardSwiper.focussedCardIndex != self.items.count{
                guard let item = self.items[self.cardSwiper.focussedCardIndex ?? 0] as? CompletedPollQuestion else { return }
                (self.items[self.cardSwiper.focussedCardIndex ?? 0] as? CompletedPollQuestion)?.hasBeenRevealed = true
                self.updateInviteButton()
                PollHelper.revealUser(poll: item) {
                    print("poll was successfully revealed")
                }
            }
        }))
        alertVC.view.tintColor = .systemTeal
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func presentInviteVC(){
        let vc = storyboard?.instantiateViewController(identifier: "InviteFriendViewController") as! InviteFriendViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func retrievePolls(){
        let lastRequestDate = User.shared!.getPollExpirationDate()
        self.updateInviteFriendsButton(pollsAvaliable: lastRequestDate < Date())
        self.inviteFriendsButton.isHidden = true
        self.findFriendsButton.isHidden = User.shared!.friends.count >= 1
        let docRef = db.collection("users").document(User.shared!.uid).collection("polls").limit(to: 12)
        docRef.getDocuments { (snapshot, error) in
            SVProgressHUD.dismiss()
            self.view.isUserInteractionEnabled = true
            self.cardSwiper.activityIndicator(show: false)
            if error == nil{
                guard let documents = snapshot?.documents else { return }
                
                var pollItems = [PollQuestion]()
                
                for document in documents{
                    if let item = PollQuestionResponse(data: document.data()){
                    pollItems.append(PollQuestion(response: item))
                    }
                }
                self.items = pollItems
                self.extraIndex  = 1
                self.cardSwiper.reloadData()
                self.updateInviteButton()
                self.inviteFriendsButton.isHidden = false
                _ = self.cardSwiper.scrollToCard(at: 0, animated: true)
            }else{
                print("poll listener snapshot error : \(error!.localizedDescription)")
            }
        }

    }
    
    func getPolls(){
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        PollHelper.getPolls { (questions) in
            self.retrievePolls()
        }
    }

}
//MARK: - Vertical card swiper delegate + datasource
extension PlayViewController : VerticalCardSwiperDelegate, VerticalCardSwiperDatasource{
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return items.count + extraIndex
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        if index == items.count{
            let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "GetGameCell", for: index) as! GetGameCellModel
            cardCell.delegate = self
            return cardCell
        }else{
            
            let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: index) as! GameCardCell
            let item = items[index]
            cardCell.delegate = self
            cardCell.setUp(poll : item)
            
            return cardCell
            
        }
        
    }
    
    
    func didScroll(verticalCardSwiperView: VerticalCardSwiperView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
        updateInviteFriendsButton(pollsAvaliable: User.shared!.getPollExpirationDate() < Date())
        updateInviteButton()
    }
    
    func updateInviteButton(){
        
        UIView.animate(withDuration: 0.2) {
            var isEnabled = self.cardSwiper.focussedCardIndex == self.items.count
            
            if self.items.count > 0 && self.cardSwiper.focussedCardIndex != self.items.count && !isEnabled{
                let item = self.items[self.cardSwiper.focussedCardIndex ?? 0]
                isEnabled = item is CompletedPollQuestion &&
                    !((item as? CompletedPollQuestion)?.hasBeenRevealed ?? false)
                if isEnabled{
                    self.inviteFriendsButton.setTitle("REVEAL YOURSELF", for: .normal)
                }
            }
            
            
            self.inviteFriendsButton.alpha = isEnabled ? 1.0 : 0.0
            self.inviteFriendsButton.isUserInteractionEnabled = isEnabled
            self.findFriendsButton.alpha = isEnabled ? 1.0 : 0.0
            self.findFriendsButton.isUserInteractionEnabled = isEnabled
            
        }
       
    }
    
}
//MARK: - PollChoiceDelegate
extension PlayViewController : PollChoiceDelegate {
    func didReloadItem(item: AnyPollQuestion) {
        guard let index = self.items.firstIndex(where: { (pollQ) -> Bool in
            return item.index == pollQ.index
        }) else { return }
        
        self.items.remove(at: index)
        self.items.insert(item, at: index)
    }
    
    
    func didChooseItem(item: CompletedPollQuestion) {
        guard let index = items.firstIndex(where: { (poll) -> Bool in
            return poll.id == item.id
        }) else { return }
        
        self.items.remove(at: index)
        self.items.insert(item, at: index)
        
        DispatchQueue.global().async {
            PollHelper.completePoll(completedPoll: item)
        }
        
        updateInviteButton()
        updateInviteFriendsButton(pollsAvaliable: false)
    }
    
}
//MARK: - Poll Avaliablity Delegate
extension PlayViewController : PollAvaliablityDelegate {
    
    func updateInviteFriendsButton(pollsAvaliable: Bool) {
        self.pollsAvaliable = pollsAvaliable
        if User.shared!.ghostMode{
                inviteFriendsButton.isHidden = true
                findFriendsButton.isHidden = true
        }else if User.shared!.friends.count < 1{
            inviteFriendsButton.isHidden = false
            findFriendsButton.isHidden = false
            inviteFriendsButton.setTitle("INVITE FRIENDS", for: .normal)
        }else {
            if items.count > 0 && cardSwiper.focussedCardIndex != items.count{
                if items[cardSwiper.focussedCardIndex ?? 0] is CompletedPollQuestion &&
                    !((items[cardSwiper.focussedCardIndex ?? 0] as? CompletedPollQuestion)?.hasBeenRevealed ?? false){
                    inviteFriendsButton.isHidden = false
                    findFriendsButton.isHidden = true
                    inviteFriendsButton.setTitle("REVEAL YOURSLEF", for: .normal)
                }
            }else{
                returnToLastCardState()
            }
        }
    }
    
    func returnToLastCardState(){
        inviteFriendsButton.isHidden = false
        findFriendsButton.isHidden = true
        if pollsAvaliable{
            inviteFriendsButton.setTitle("PLAY NOW", for: .normal)
        }else{
            inviteFriendsButton.setTitle("INVITE A FRIEND", for: .normal)
        }
    }
    
    
}

//MARK: - SPPermissions delegate + datasource
extension PlayViewController : SPPermissionsDelegate, SPPermissionsDataSource{
    func configure(_ cell: SPPermissionTableViewCell, for permission: SPPermission) -> SPPermissionTableViewCell {
        cell.iconView.color = .label
        cell.button.allowedBackgroundColor = .systemBlue
        cell.button.allowTitleColor = .systemBlue
        
        return cell
    }
    
    func showContactsDialog(){
        let controller = SPPermissions.dialog([.contacts])

            // Ovveride texts in controller
            controller.titleText = "Invite A Friend"
            controller.headerText = "Permissions Required"
            controller.footerText = "Access to your contacts is required to invite a friend. This is required to find who is already using Swish."

            // Set `DataSource` or `Delegate` if need.
            // By default using project texts and icons.
            controller.dataSource = self
            controller.delegate = self

            // Always use this method for present
            controller.present(on: self)
        
    }
    
    func didAllow(permission: SPPermission) {
        presentInviteVC()
    }
}

//
//  AddFriendsViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/7/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import CollectionViewWaterfallLayout
import SPPermissions

class AddFriendsViewController: UIViewController {
    
    var friends = [GenericUser]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hasFetchedData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFriends()
        self.setUpCollectionView()
        self.collectionView.activityIndicator(show: true)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Find Friends"
        // Do any additional setup after loading the view.
    }
    
    func getFriends(){
        FriendshipHelper.getRecommendedUsers { (users) in
            self.hasFetchedData = true
            self.collectionView.activityIndicator(show: false)
            self.friends = users
            self.collectionView.reloadData()
        }
    }
    
    func setUpCollectionView(){
           collectionView.delegate = self
           collectionView.dataSource = self
        
           collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "ButttonHeader")
    
           collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
           let layout = CollectionViewWaterfallLayout()
           
           layout.columnCount = 2
           layout.minimumColumnSpacing = 8
           layout.minimumInteritemSpacing = 8
           layout.headerHeight = 82
        
           collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
           collectionView.collectionViewLayout = layout
       }
    
    @objc func contactsButtonPressed(){
        if SPPermission.contacts.isAuthorized{
            presentFindFriendsVC()
        }else{
            showContactsDialog()
        }
    }
    
    func presentFindFriendsVC(){
        let storyboard = UIStoryboard(name: "Play", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "InviteFriendViewController") as! InviteFriendViewController
        navigationController?.pushViewController(vc, animated: true)
    }


}

//MARK: - UICOLLEctionview delegate + Datasource

extension AddFriendsViewController : UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if friends.count == 0 && hasFetchedData{
            collectionView.setEmptyView(title: "No Friends Found", message: "You have no suggested friends for now, try finding friends through your contacts", messageImage: UIImage.init(systemName: "person")!)
        }else{
            collectionView.restore()
        }
        return friends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let friend = friends[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendCollectionViewCell", for: indexPath) as! MyFriendCollectionViewCell
        
        cell.setUpCell(user: friend)
        cell.pointsLabel.text = "Recommended"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        ProfileViewController.present(user: friend, viewController: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ButttonHeader", for: indexPath)
        let contactsButton = BasicButton(frame: CGRect(x: 16, y: 16, width: collectionView.frame.width-32, height: 50))
        contactsButton.awakeFromNib()
        contactsButton.backgroundColor = .systemTeal
        contactsButton.setTitle("FIND FRIENDS IN CONTACTS", for: .normal)
        contactsButton.setTitleColor(.white, for: .normal)
        contactsButton.titleLabel?.font = AppHelper.shared.boldFont(of: 17)
        contactsButton.addTarget(self, action: #selector(contactsButtonPressed), for: .touchUpInside)
        header.addSubview(contactsButton)
        return header
    }
    
    
}

//MARK: - SPPermissions delegate + datasource
extension AddFriendsViewController : SPPermissionsDelegate, SPPermissionsDataSource{
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
        presentFindFriendsVC()
    }
}

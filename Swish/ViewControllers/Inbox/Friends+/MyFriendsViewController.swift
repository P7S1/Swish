//
//  MyFriendsViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/7/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import CollectionViewWaterfallLayout
import FirebaseFirestore
class MyFriendsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var friends = [User]()
    
    var friendsToFetch = [String]()
    
    var lastRequestedUserId : String?
    
    var requestedAllFriends = false
    
    var hasFetchedData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        self.friendsToFetch = User.shared!.friends
        self.collectionView.activityIndicator(show: true)
        getFriends()
    }
    
    func setUpCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
 
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        let layout = CollectionViewWaterfallLayout()
        
        layout.columnCount = 2
        layout.minimumColumnSpacing = 8
        layout.minimumInteritemSpacing = 8
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.collectionViewLayout = layout
    }
    
    func getFriends(){
        var idPayLoad = [String]()
        for _ in 0...9 {
            if !requestedAllFriends && friendsToFetch.count > 0{
                idPayLoad.append(friendsToFetch[0])
                friendsToFetch.remove(at: 0)
            }else{
                hasFetchedData = true
                requestedAllFriends = true
                break
            }
        }
        
        if !idPayLoad.isEmpty{
            fetchFriends(iDs: idPayLoad)
        }else{
            hasFetchedData = true
            requestedAllFriends = true
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.activityIndicator(show: false)
            }
        }
    }
    
    
    private func fetchFriends(iDs : [String]){
        let docRef = db.collection("users").whereField("uid", in: iDs).limit(to: 10)
        docRef.getDocuments { (snapshot, error) in
            self.collectionView.activityIndicator(show: false)
            self.hasFetchedData = true
            if error == nil{
                for document in snapshot!.documents{
                    if let friend = User(data: document.data()){
                        self.friends.append(friend)
                    }
                    self.collectionView.reloadData()
                }
            }else{
                print("there was a get friends error : \(error!.localizedDescription)")
            }
        }
    }
    

}


//MARK: - UICOLLEctionview delegate + Datasource

extension MyFriendsViewController : UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if friends.count == 0 && hasFetchedData{
            collectionView.setEmptyView(title: "You haven't added any", message: "Find friends through your contacts or by our recommendations", messageImage: UIImage.init(systemName: "person")!)
        }else{
            collectionView.restore()
        }
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let friend = friends[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendCollectionViewCell", for: indexPath) as! MyFriendCollectionViewCell
        
        cell.setUpCell(user: friend)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        ProfileViewController.present(user: friend, viewController: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == friends.count-1{
            self.getFriends()
        }
    }
    
    
}

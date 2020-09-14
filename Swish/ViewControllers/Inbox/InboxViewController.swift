//
//  InboxViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/25/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import FirebaseFirestore
import DeepDiff

class InboxViewController: HomeViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items : [InboxItem] = [InboxItem]()
    
    var lastDocument : DocumentSnapshot?
    
    var originalQuery : Query!
    
    var query : Query!
    
    var loadedAllDocuments = false
    
    var refreshControl : UIRefreshControl!
    
    var hasFetchedData = false
    
    @IBOutlet weak var inviteFriendsButton: BasicButton!
    
    override func viewDidLoad() {
        self.setupUI(title: "Inbox")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 82, right: 0)
        inviteFriendsButton.addShadows()
        
        configureInitialQuery()
        configureRefreshContorl()
        getInboxItems(removeAll: false)
        
        NotificationsHelper.shared.registerForPushNotifications()
    }
    
    @objc func refresh(){
        refreshControl.beginRefreshing()
        getInboxItems(removeAll: true)
    }
    
    func configureRefreshContorl(){
        self.tableView.activityIndicator(show: true)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        let string = NSAttributedString(string: "PULL TO REFRESH", attributes: [NSAttributedString.Key.font : AppHelper.shared.mediumFont(of: 13), NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel])
        tableView.refreshControl?.attributedTitle = string
    }
    
    func configureInitialQuery(){
        let last24 = Calendar.current.date(byAdding: .hour, value: -24, to: Date())
        self.originalQuery = db.collection("users").document(User.shared!.uid).collection("inbox").whereField("creationDate", isGreaterThanOrEqualTo: Timestamp(date: last24!)).order(by: "creationDate", descending: true).limit(to: 20)
        self.query = originalQuery
    }
    
    func getInboxItems(removeAll : Bool){
            if removeAll{
                self.lastDocument = nil
                self.query = self.originalQuery
                self.loadedAllDocuments = false
            }
            if let doc = self.lastDocument{
                self.query = self.query.start(afterDocument: doc)
            }
            self.query.getDocuments { (snapshot, error) in
                self.hasFetchedData = true
                if error == nil{
                    self.tableView.activityIndicator(show: false)
                    if snapshot!.count < 20{
                        self.loadedAllDocuments = true
                    }
                    
                    let oldItems = self.items
                    var newItems = oldItems
                    
                    if removeAll{
                        newItems.removeAll()
                    }
                    
                    for document in snapshot!.documents{
                        if let item = InboxItem(data: document.data()){
                            newItems.append(item)
                            self.lastDocument = document
                        }
                    }
                    let changes = diff(old: oldItems, new: newItems)
                    DispatchQueue.main.async {
                        self.tableView.reload(changes: changes, section: 0, updateData: {
                          self.items = newItems
                        })
                        self.refreshControl.endRefreshing()
                    }
                    
                }else{
                    print("getting inbox Item error : \(error!.localizedDescription)")
                }
            }
    }

    @IBAction func friendsButtonPressed(_ sender: Any) {
        let vc = FriendsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
//tableview stuff
extension InboxViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 && hasFetchedData{
            tableView.setEmptyView(title: "Your inbox is empty", message: "If someone picked you in a poll witihin the last 24 hours, it will appear here. Invite your friends to receive anonymous votes", messageImage: UIImage.init(systemName: "envelope")!)
        }else{
            tableView.restore()
        }
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxItemTableViewCell") as! InboxItemTableViewCell
        
        let item = items[indexPath.row]
        
        cell.setUpCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewInboxItemViewController") as! ViewInboxItemViewController
        
        vc.inboxItem = items[indexPath.row]
        items[indexPath.row].hasBeenOpened = true
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count-1{
            if !loadedAllDocuments{
                getInboxItems(removeAll: false)
            }
        }
    }
    

}

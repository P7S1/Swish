//
//  InviteFriendViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/6/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import Contacts
import MessageUI
import Firebase
class InviteFriendViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var contacts = [FetchedContact]()
    
    var contactsWithSwish = [FirebaseContactResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton
        self.navigationItem.largeTitleDisplayMode = .never
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.title = "Invite A Friend"
        getContacts()
        
        // Do any additional setup after loading the view.
    }
    
    func getContacts(){
        let store = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        request.sortOrder = .givenName
        do {
            // 3.
            var phoneNumbers = [String]()
            try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                if let number = contact.phoneNumbers.first?.value.stringValue{
                var formattedNumber = number.digits
                    if !(formattedNumber.prefix(1) == "1") && formattedNumber.count < 10{
                        formattedNumber = "+1\(formattedNumber)"
                    }else if formattedNumber.count == 10{
                        formattedNumber = "+1\(formattedNumber)"
                    }else{
                        formattedNumber = "+\(formattedNumber)"
                    }
                    phoneNumbers.append(formattedNumber)
                self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: formattedNumber))
                }
            })
            
            FindFriendsHelper.storeContactsOnDatabase(phoneNumbers: phoneNumbers)
            FindFriendsHelper.getUserIDsWithPhoneNumber(phoneNumbers: phoneNumbers) { (result) in
                self.contactsWithSwish = result
                self.tableView.reloadData()
            }
            
            contacts.sort()
            tableView.reloadData()
        } catch let error {
            print("Failed to enumerate contact", error)
        }
    }
    

}

 //MARK: - TableView FUnctions

extension InviteFriendViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendsTableViewCell") as! InviteFriendsTableViewCell
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = "\(contact.firstName) \(contact.lastName)"
        cell.usesSwishLabel.text = contact.telephone
        
        if contactsWithSwish.contains(where: { (item) -> Bool in
            item.phoneNumber == contact.telephone
        }){
            //USER USEES SWISH
            cell.inviteButton.backgroundColor = .systemPink
            cell.inviteButton.setTitle("VIEW PROFILE", for: .normal)
            
            cell.inviteButtonAction = { () in
                
                if let index = self.contactsWithSwish.firstIndex(where: { (item) -> Bool in
                    return item.phoneNumber == contact.telephone
                }){
                    let item = self.contactsWithSwish[index]
                    let docRef = db.collection("users").document(item.uid)
                    
                    docRef.getDocument { (document, error) in
                        if error == nil{
                            if let data = document!.data(), let user = User(data: data){
                                ProfileViewController.present(user: user, viewController: self)
                            }
                        }
                    }
                }
                
            }
        }else{
            //USER DOES NOT USE SWISH
            cell.inviteButton.backgroundColor = .systemTeal
            cell.inviteButton.setTitle("INVITE", for: .normal)
            cell.inviteButtonAction = { () in
                self.presentInviteViewWithRefferralId(contact: contact)
            }
        }
        return cell
    }
    
    
}

//MARK: - MFMessageComposeViewControllerDelegate
extension InviteFriendViewController : MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func presentMessageController(contact: FetchedContact, link : URL){
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "You're invited to play Swish \(link)"
            controller.recipients = [contact.telephone]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    func presentInviteViewWithRefferralId(contact: FetchedContact){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let link = URL(string: "https://playswish.com/referral/?referralId=\(uid)")
        let referralLink = DynamicLinkComponents(link: link!, domainURIPrefix: "https://playswish.com/referral")
        
        referralLink?.shorten { (shortURL, warnings, error) in
            if let error = error {
                   print(error.localizedDescription)
                   return
            }
            guard let url = shortURL else { return }
            self.presentMessageController(contact: contact, link: url)
        }
    }

}

//
//  SettingsTableViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/4/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SCSDKBitmojiKit
import SCSDKLoginKit
class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var ghostModeLabel: UILabel!
    
    @IBOutlet weak var refreshBitmojiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Settings"
        if User.shared!.ghostMode{
            ghostModeLabel.text = "Turn off Ghost Mode"
        }else{
            ghostModeLabel.text = "Turn on Ghost Mode"
        }
        if SCSDKLoginClient.isUserLoggedIn{
            refreshBitmojiLabel.text = "Refresh bitmoji🤺"
        }else{
            refreshBitmojiLabel.text = "Link to Snapchat👻"
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return getHeaderView(with: "MY ACCOUNT", tableView: tableView)
        case 1:
            return getHeaderView(with: "GENERAL", tableView: tableView)
        case 2:
            return getHeaderView(with: "SUPPORT", tableView: tableView)
        case 3:
            return getHeaderView(with: "LEGAL", tableView: tableView)
        default:
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            handleMyAccount(row: indexPath.row)
        case 1:
            handleGeneral(row: indexPath.row)
        case 2:
            handleSupport(row: indexPath.row)
        case 3:
            handleLegal(row: indexPath.row)
        default:
            logout()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    //MARK: - Handle each and every section
    
    func handleMyAccount(row: Int){
        switch row {
        case 0:
            handleToggleGhostMode()
        case 1:
            let vc = UIAlertController(title: "Can't change school", message: "You are only able to change your school once every 30 days. Contact us via email to change your school earlier.", preferredStyle: .alert)
            vc.view.tintColor = .systemTeal
            vc.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                vc.dismiss(animated: true, completion: nil)
            }))
            self.present(vc, animated: true, completion: nil)
        default:
            self.view.isUserInteractionEnabled = false
            SVProgressHUD.show()
            if !(SCSDKLoginClient.isUserLoggedIn){
                SCSDKLoginClient.login(from: self) { (completed, error) in
                    if error != nil {
                        print("there was a logging in snapchat Error : \(error!.localizedDescription)")
                    }
                    if completed{
                        SnapchatHelper.retrieveFirebaseAuthToken { (accessToken, bitmojiURL, externalId) in
                            let credential = OAuthProvider.credential(withProviderID: "snapchat.com", accessToken: accessToken)
                            Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
                                if error == nil{
                                    SVProgressHUD.showSuccess(withStatus: "Snapchat successfully linked")
                                    self.reloadBitmoji()
                                }else{
                                    print("there was an error linknig to snaphcat : \(error!.localizedDescription)")
                                }
                            })
                        }
                    }
                }
            }else{
                reloadBitmoji()
            }
        }
    }
    
    func reloadBitmoji(){
        SCSDKBitmojiClient.fetchAvatarURL { (avatarURL: String?, error: Error?) in
            if error == nil{
                let docRef = db.collection("users").document(User.shared!.uid)
                docRef.setData(["bitmojiURL":avatarURL ?? ""], merge: true) { (error) in
                    self.view.isUserInteractionEnabled = true
                    if error == nil{
                        SVProgressHUD.showSuccess(withStatus: "Bitmoji successfully refreshed")
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        SVProgressHUD.showError(withStatus: "Bitmoji Error")
                        self.navigationController?.popViewController(animated: true)
                        print("there was a saving bitmoji errro :\(error!.localizedDescription)")
                    }
                }
            }else{
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.showError(withStatus: "Bitmoji error, try logging out then logging back in")
                self.navigationController?.popViewController(animated: true)
                print("there was a scsdkbitmoji error: \(error!.localizedDescription)")
            }
        }
    }
    
    func handleGeneral(row: Int){
        switch row {
        case 0:
            requestReviewManually()
        case 1:
            //submit a qquestion
            let vc = storyboard?.instantiateViewController(identifier: "SubmitQuestionViewController") as! SubmitQuestionViewController
            navigationController?.pushViewController(vc, animated: true)
        default:
            //share profile
            shareProfile()
        }
    }
    
    func handleSupport(row: Int){
        let vc = UIAlertController(title: "Contact", message: "Email: contactswishapp@gmail.com", preferredStyle: .alert)
        vc.view.tintColor = .systemTeal
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (action) in
            UIPasteboard.general.string = "contactswishapp@gmail.com"
            SVProgressHUD.showSuccess(withStatus: "Copied to clipboard")
            vc.dismiss(animated: true, completion: nil)
        }))
        self.present(vc, animated: true, completion: nil)
    }
    
    func handleLegal(row: Int){
        switch row {
        case 0:
            //terms of service
            launchWebView(title: "Terms of Service", link: "https://www.playswish.com/terms-of-service")
        default:
            //privacy policy
            launchWebView(title: "Privacy Policy", link: "https://www.playswish.com/privacy")
        }
    }
    
    //MARK: - Handle addiitonal functions
    func handleToggleGhostMode(){
        if User.shared!.ghostMode{
            turnOffGhostMode()
        }else{
            turnOnGhostMode()
        }
    }
    
    func turnOffGhostMode(){
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let docRef = db.collection("users").document(User.shared!.uid)
        docRef.setData(["ghostMode":false], merge: true) { (error) in
            self.view.isUserInteractionEnabled = true
            if error == nil{
                SVProgressHUD.showSuccess(withStatus: "Ghost Mode is Off")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func turnOnGhostMode(){
        let vc = UIAlertController(title: "Are you sure you want to turn on ghost mode?", message: "When ghost mode is on, you will not show up on polls.", preferredStyle: .alert)
        vc.view.tintColor = .systemTeal
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.addAction(UIAlertAction(title: "Turn on", style: .destructive, handler: { (alert) in
            self.view.isUserInteractionEnabled = false
            SVProgressHUD.show()
            let docRef = db.collection("users").document(User.shared!.uid)
            docRef.setData(["ghostMode":true], merge: true) { (error) in
                if error == nil{
                    SVProgressHUD.showSuccess(withStatus: "Ghost Mode is On")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        self.present(vc, animated: true, completion: nil)
    }
    
    func launchWebView(title : String, link : String){
        print("launch webview")
        let vc = WebViewController()
        vc.navTitle = title
        vc.url = URL(string: link)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func requestReviewManually() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id\(AppHelper.appstoreID)?action=write-review")
            else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
    func shareProfile() {
           let uid = User.shared!.uid
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
           activityViewController.popoverPresentationController?.sourceView = self.tableView // so that iPads won't crash
           // present the view controller
           self.present(activityViewController, animated: true, completion: nil)
       }
    
    
    func logout(){
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (alert) in
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            SCSDKLoginClient.clearToken()
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            self.view.isUserInteractionEnabled = false
            SVProgressHUD.show()
            NotificationsHelper.removeFirestorePushToken { (error) in
                do {
                    try Auth.auth().signOut()
                    SVProgressHUD.dismiss()
                    self.returnToLoginScreen()
                }catch let err{
                    print("signing out error : \(err.localizedDescription)")
                }
            }
        }))
        alertController.view.tintColor = .systemTeal
        self.present(alertController, animated: true, completion: nil)
    }
}

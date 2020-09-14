//
//  CodeViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/27/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SCSDKLoginKit
import SVProgressHUD
class CodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: BasicTextField!
    @IBOutlet weak var verifyButton: BasicButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton
        
        textField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func verifyButtonPressed(_ sender: Any) {
        let codeString = (textField.text ?? "").digits
        if codeString.count == 6{
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
            SVProgressHUD.show()
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: codeString)
            if SCSDKLoginClient.isUserLoggedIn{
                linkAuthCredentialToSnapchat(credential: credential)
            }else{
                logInWithPhoneNumber(credential: credential)
            }
        }else{
            self.textField.shake()
        }
    }
    
    func logInWithPhoneNumber(credential : AuthCredential){
        Auth.auth().signIn(with: credential) { (result, error) in
            if error == nil{
                let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                docRef.getDocument { (snapshot, error) in
                    if snapshot?.exists ?? false{
                        notificationCenter.post(name: Notification.Name("logUserIn"), object: nil)
                    }else{
                        UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "externalId")
                        self.continueToNameViewController()
                    }
                }
            }else{
                print("there was an erorr logging in with phone number : \(error!.localizedDescription)")
                self.textField.shake()
            }
        }
    }
    
    func linkAuthCredentialToSnapchat(credential : AuthCredential){
        Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
            SVProgressHUD.dismiss()
            if error == nil{
                self.continueToNameViewController()
            }else{
                print("there was an auth credentials link error: \(error!.localizedDescription)")
                self.textField.shake()
            }
        })
    }
    
    func continueToNameViewController(){
        SVProgressHUD.dismiss()
        let vc = self.storyboard?.instantiateViewController(identifier: "NameViewController") as! NameViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.viewControllers.removeFirst(3)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.digits.count == string.count && ((textField.text?.count ?? 0) + string.count) <= 6
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

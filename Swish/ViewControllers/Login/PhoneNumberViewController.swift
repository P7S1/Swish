//
//  PhoneNumberViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/27/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
class PhoneNumberViewController: UIViewController, AuthUIDelegate {

    @IBOutlet weak var textField: BasicTextField!
    @IBOutlet weak var continueButton: BasicButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Phone Number"

        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton
        
        textField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func continueButtonPressed(_ sender: Any) {
        continueButton.isUserInteractionEnabled = false
        SVProgressHUD.show()
        let phoneNumberString = (textField.text ?? "").digits
    
        if phoneNumberString.count == 10{
            Auth.auth().settings?.isAppVerificationDisabledForTesting = false
            
            PhoneAuthProvider.provider().verifyPhoneNumber("+1\(phoneNumberString)", uiDelegate: self) { (verificationID, error) in
                self.continueButton.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                if error == nil{
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    let vc = self.storyboard?.instantiateViewController(identifier: "CodeViewController") as! CodeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    self.textField.shake()
                    print("there was an errror: \(error!.localizedDescription)")
                }
            }
            
            }else{
                self.textField.shake()
            }
        
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

extension PhoneNumberViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if textField == textField{

            return checkEnglishPhoneNumberFormat(string: string, str: str)

        }else{

            return true
        }
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{

        if string == ""{ //BackSpace

            return true

        }else if str!.count < 3{

            if str!.count == 1{

                textField.text = "("
            }

        }else if str!.count == 5{

            textField.text = textField.text! + ") "

        }else if str!.count == 10{

            textField.text = textField.text! + "-"

        }else if str!.count > 14{

            return false
        }

        return true
    }
    
}

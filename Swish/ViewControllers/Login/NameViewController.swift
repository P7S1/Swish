//
//  NameViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/26/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import SCSDKBitmojiKit
import Kingfisher
import FirebaseAuth
class NameViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var continueButton: BasicButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton
        // Do any additional setup after loading the view.
        
        SCSDKBitmojiClient.fetchAvatarURL { (url, error) in
            if error == nil{
                self.imageView.kf.setImage(with: Auth.auth().currentUser?.photoURL)
                
            }else{
                print("bitmoji error : \(error!.localizedDescription)")
            }
        }
    }
    

    @IBAction func continueButtonPressed(_ sender: Any) {
        let firstNameBool = (firstNameTextField.text ?? "").count > 1
        let lastNameBool =  (lastNameTextField.text ?? "").count > 1
        
        if firstNameBool && lastNameBool{
        
        UserDefaults.standard.set(firstNameTextField.text!, forKey: "firstName")
        UserDefaults.standard.set(lastNameTextField.text!, forKey: "lastName")
            
        let vc = storyboard?.instantiateViewController(identifier: "GenderViewController") as! GenderViewController
        navigationController?.pushViewController(vc, animated: true)
        }else{
            if !firstNameBool{
                firstNameTextField.shake()
            }
            
            if !lastNameBool{
                lastNameTextField.shake()
            }
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

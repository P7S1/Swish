//
//  SetupCompleteViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/29/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseFirestore
import FirebaseAuth
class SetupCompleteViewController: UIViewController {

    @IBOutlet weak var doneButton: BasicButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Setup Complete"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton
        
    }
    

    @IBAction func doneButtonPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        doneButton.isUserInteractionEnabled = false
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        let user = User()
        
        if let data = user.getDictionary(){
            
            docRef.setData(data) { (error) in
                self.doneButton.isUserInteractionEnabled = true
                if error == nil{
                    notificationCenter.post(name: Notification.Name("logUserIn"), object: nil)
                    SVProgressHUD.dismiss()
                }else{
                    SVProgressHUD.showError(withStatus: "Account Error")
                    print("there was an error \(error!.localizedDescription)")
                }
            }
            
        }
        
        
    }

}

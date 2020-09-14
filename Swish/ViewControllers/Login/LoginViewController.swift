//
//  LoginViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/25/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import FirebaseAuth
import FirebaseFunctions
import SVProgressHUD
class LoginViewController: UIViewController {

    @IBOutlet weak var snapchatImageView: UIImageView!
    @IBOutlet weak var loginButton: BasicButton!
    
    @IBOutlet weak var phoneLoginButton: BasicButton!
    @IBOutlet weak var emitterView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton
        
        snapchatImageView.layer.cornerRadius = snapchatImageView.frame.size.height/2
        
        startEmitter()
        // Do any additional setup after loading the view.
    }
    
    func startEmitter(){
        let emitterLayer = CAEmitterLayer()
            
        emitterLayer.emitterPosition = CGPoint(x: emitterView.frame.width/2, y: -40)
        emitterLayer.emitterSize = CGSize(width: emitterView.frame.width, height: 1)
        emitterLayer.emitterShape = .line
        emitterLayer.emitterCells = getEmitterCells()
        emitterLayer.birthRate = 0.125
        emitterView.layer.addSublayer(emitterLayer)
    }
    
    func getEmitterCells() -> [CAEmitterCell]{
        var cells = [CAEmitterCell]()
        
        for i in 0...33{
            let cell = CAEmitterCell()
            cell.birthRate = Float.random(in: 0.85...1.0)
            cell.lifetime = 20
            cell.velocity = CGFloat(Int.random(in: 50...100))
            cell.scale = 0.085
            cell.scaleRange = 0.005
            cell.emissionRange = CGFloat.pi/4
            cell.emissionLongitude = (180 * (.pi / 180))
            cell.alphaRange = 0.3
            cell.yAcceleration = CGFloat.random(in: 10...20)
            if let image = UIImage(named: "emoji_\(i)")?.cgImage{
                cell.contents = image
                cells.append(cell)
            }
        }
        
        return cells
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func phoneLoginButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "PhoneNumberViewController") as! PhoneNumberViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        SCSDKLoginClient.login(from: self) { (success : Bool, error : Error?) in
            // do something
            if success{
                DispatchQueue.main.async {
                    SVProgressHUD.show()
                    self.loginButton.isUserInteractionEnabled = false
                }
                SnapchatHelper.retrieveFirebaseAuthToken { (accessToken, bitmojiURL, externalId)  in
                    Auth.auth().signIn(withCustomToken: accessToken) { (result, error) in
                        if error == nil{
                            self.loginButton.isUserInteractionEnabled = true
                            UserDefaults.standard.set(externalId, forKey: "externalId")
                            if Auth.auth().currentUser?.phoneNumber == nil{
                                
                                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                changeRequest?.photoURL = URL(string: bitmojiURL ?? "")
                                changeRequest?.commitChanges { (error) in
                                
                                SVProgressHUD.dismiss()
                                let vc = self.storyboard?.instantiateViewController(identifier: "PhoneNumberViewController") as! PhoneNumberViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                                
                            }else{
                                notificationCenter.post(name: Notification.Name("logUserIn"), object: nil)
                            }
                            
                        }else{
                            print("there was an error: \(error!)")
                            SVProgressHUD.showError(withStatus: "Authentication Failed")
                        }
                    }
                }

            }else{
                print("snapcaht sdk login error : \(error!.localizedDescription)")
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


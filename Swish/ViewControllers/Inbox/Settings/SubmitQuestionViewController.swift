//
//  SubmitQuestionViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/13/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseFirestore
import SVProgressHUD

class SubmitQuestionViewController: UIViewController {

    @IBOutlet weak var imageView: AnimatedImageView!
    @IBOutlet weak var submitButton: BasicButton!
    
    @IBOutlet weak var textField: UITextField!
    var selectedGifURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = " " //in your case it will be empty or you can put the title of your choice
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        imageView.layer.cornerRadius = imageView.frame.height * 0.1
        imageView.layer.masksToBounds = true
        
        checkSubmitButton()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    func setSubmitButtonDisabledState(){
        submitButton.isEnabled = false
        submitButton.backgroundColor = .secondarySystemBackground
        submitButton.setTitleColor(.secondaryLabel, for: .normal)
        submitButton.alpha = 0.4
    }
    
    func setSubmitButtonEnabledState(){
        submitButton.isEnabled = true
        submitButton.backgroundColor = .systemPink
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.alpha = 1.0
    }
    
    func checkSubmitButton(){
        if (textField.text ?? "").count > 5 && selectedGifURL != nil{
            setSubmitButtonEnabledState()
        }else{
            setSubmitButtonDisabledState()
        }
    }
    
    @IBAction func selectAGifButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "GifViewController") as! GifViewController
        vc.gifDeleagte = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        let docRef = db.collection("submittedQuestions").document()
        let question = SubmittedQuesiton(questionText: textField.text!, photoURL: selectedGifURL!, isApproved: false, id: docRef.documentID)
        if let data = question.getDictionary(){
            docRef.setData(data) { (error) in
                if error == nil{
                    SVProgressHUD.showSuccess(withStatus: "Question Submitted")
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: "Question Error")
                    print("there was an error \(error!.localizedDescription)")
                }
            }
        }
        
    }
    
    @objc func textFieldDidChange(){
        checkSubmitButton()
    }

}

extension SubmitQuestionViewController : GifDelegate{
    func didSelectItem(gif: URL, vc: GifViewController) {
        self.imageView.kf.setImage(with: gif)
        self.selectedGifURL = gif
        vc.navigationController?.popViewController(animated: true)
        checkSubmitButton()
    }
}

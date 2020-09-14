//
//  GenderViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/27/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class GenderViewController: UIViewController {
    
    
    @IBOutlet weak var maleButton: BasicButton!
    @IBOutlet weak var femaleButton: BasicButton!
    @IBOutlet weak var genderButton: BasicButton!
    
    let vc : GradeTableViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "GradeTableViewController") as! GradeTableViewController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton
        // Do any additional setup after loading the view.
    }

    @IBAction func maleButtonPressed(_ sender: Any) {
        navigationController?.pushViewController(vc, animated: true)
        UserDefaults.standard.set("male", forKey: "gender")
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
        navigationController?.pushViewController(vc, animated: true)
        UserDefaults.standard.set("female", forKey: "gender")
    }
    
    @IBAction func nonBinaryButtonPressed(_ sender: Any) {
        navigationController?.pushViewController(vc, animated: true)
        UserDefaults.standard.set("non-binary", forKey: "gender")
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

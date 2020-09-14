//
//  JoinSchoolViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/27/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import SPPermissions
class JoinSchoolViewController: UIViewController {

    @IBOutlet weak var searchNearbySchoolsButton: BasicButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchNeabySchoolsButtonPressed(_ sender: Any) {
        
        if SPPermission.locationWhenInUse.isAuthorized {
           showNearbySchoolsVC()
        } else {
           showLocationDialog()
        }
        
    }
    
    func showNearbySchoolsVC(){
        let vc = storyboard?.instantiateViewController(identifier: "NearbySchoolsViewController") as! NearbySchoolsViewController
        
        navigationController?.pushViewController(vc, animated: true)
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


extension JoinSchoolViewController : SPPermissionsDataSource, SPPermissionsDelegate{
    
    func configure(_ cell: SPPermissionTableViewCell, for permission: SPPermission) -> SPPermissionTableViewCell {
        
        cell.iconView.color = .label
        cell.button.allowedBackgroundColor = .systemBlue
        cell.button.allowTitleColor = .systemBlue
        
        return cell
    }
    
    func didAllow(permission: SPPermission) {
        showNearbySchoolsVC()
    }
    
    func showLocationDialog(){
            let controller = SPPermissions.dialog([.locationWhenInUse])

            // Ovveride texts in controller
            controller.titleText = "Join Your School"
            controller.headerText = "Permissions Required"
            controller.footerText = "Your location is required to list nearby schools. You will be able to choose your school network to join after enable location access."

            // Set `DataSource` or `Delegate` if need.
            // By default using project texts and icons.
            controller.dataSource = self
            controller.delegate = self

            // Always use this method for present
            controller.present(on: self)
        
    }
}

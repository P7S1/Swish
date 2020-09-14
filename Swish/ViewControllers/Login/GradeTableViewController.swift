//
//  GradeTableViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/27/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

class GradeTableViewController: UITableViewController {
    
    let joinSchoolVC : JoinSchoolViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "JoinSchoolViewController") as! JoinSchoolViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "School"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            middleSchool(row: indexPath.row)
            UserDefaults.standard.set("middle_school", forKey: "schoolLevel")
        case 1:
            highSchool(row: indexPath.row)
            UserDefaults.standard.set("high_school", forKey: "schoolLevel")
        case 2:
            college(row: indexPath.row)
            UserDefaults.standard.set("college", forKey: "schoolLevel")
        default:
            return
        }
        
        navigationController?.pushViewController(joinSchoolVC, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return getHeaderView(with: "MIDDLE SCHOOL", tableView: tableView)
        case 1:
            return getHeaderView(with: "HIGH SCHOOL", tableView: tableView)
        default:
            return getHeaderView(with: "COLLEGE", tableView: tableView)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func middleSchool(row : Int){
            UserDefaults.standard.set("middle_school", forKey: "grade")
    }
    
    func highSchool(row : Int){
        
        switch row {
        case 0:
            UserDefaults.standard.set("freshman", forKey: "grade")
        case 1:
            UserDefaults.standard.set("sophomore", forKey: "grade")
        case 2:
            UserDefaults.standard.set("junior", forKey: "grade")
        case 3:
            UserDefaults.standard.set("senior", forKey: "grade")
        case 4:
            UserDefaults.standard.set("finished_hs", forKey: "grade")
        default:
            return
        }
    }
    
    func college(row : Int){
        
        switch row {
        case 0:
            UserDefaults.standard.set("first_year", forKey: "grade")
        case 1:
            UserDefaults.standard.set("second_year", forKey: "grade")
        case 2:
            UserDefaults.standard.set("third_year", forKey: "grade")
        case 3:
            UserDefaults.standard.set("fourth_year", forKey: "grade")
        default:
            return
        }
        
    }


    
    

}

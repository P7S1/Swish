//
//  NearbySchoolsViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/28/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
class NearbySchoolsViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var items : [GooglePlace] = [GooglePlace]()

    let locManager = CLLocationManager()
    
    var types = ["school"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Find Nearby Schools"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = BarButtonHelper.backButton
        
        let image = UIImage(named: "googleAttribution")
        let imageView = UIImageView(image: image)
        
        navigationItem.titleView = imageView
        
        searchBar.searchTextField.addDoneButtonOnKeyboard()
        searchBar.delegate = self
        
        searchBar.searchTextField.font = AppHelper.shared.mediumFont(of: 17)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getNearbySchools()
        
        setSchoolTypes()
        
        
       // Do any additional setup after loading the view.
    }
    
    func setSchoolTypes(){
        
        guard let schoolLevel = UserDefaults.standard.value(forKey: "schoolLevel") as? String else { return }
        
        if schoolLevel == "middle_school"{
            
            types = ["secondary_school"]
            
        }else if schoolLevel == "college"{
            
            types = ["school"]
            
        }else{
            
            types = ["school"]
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.performSchoolSearch(query: query)
    }
    
    func performSchoolSearch(query : String){
        SVProgressHUD.show()
        GoogleDataProvider.shared.searchPlaces(near: locManager.location!.coordinate, query: query, types: types) { (places) in
            SVProgressHUD.dismiss()
            self.items = Array(Set(places))
            self.removeElementarySchools()
            self.tableView.reloadData()
        }
        
        
    }
    
    func getNearbySchools(){
        SVProgressHUD.show()
        GoogleDataProvider.shared.fetchPlaces(near: locManager.location!.coordinate, types: types) { (places) in
                SVProgressHUD.dismiss()
               self.items = Array(Set(places))
                self.removeElementarySchools()
               self.tableView.reloadData()
        }

    }
    
    func removeElementarySchools(){
        self.items.removeAll { (place) -> Bool in
            return place.types.contains("primary_school")
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

extension NearbySchoolsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        UserDefaults.standard.set(item.placeId, forKey: "schoolID")
        UserDefaults.standard.set(item.name, forKey: "schoolName")
        
        let vc = storyboard?.instantiateViewController(identifier: "SetupCompleteViewController") as! SetupCompleteViewController
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getHeaderView(with:"SELECT THE LAST/CURRENT SCHOOL YOU ATTEND", tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolLocationTableViewCell") as! SchoolLocationTableViewCell
        
        let item = items[indexPath.row]
        
        cell.nameLabel.text = item.name
        
        cell.addressLabel.text = nil
        
        if let address = item.address{
            cell.addressLabel.text = address
        }
        
        if let address = item.vicinity{
            cell.addressLabel.text = address
        }
        
        
        return cell
    }
    
    
}

//
//  HamburgerViewController.swift
//  Digout
//
//  Created by Daniel Burkhardt on 11/6/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Class Variables
    var defaults = UserDefaults.standard
    let apiInfo = APIInfo()
    let userAccountManager = UserAccountManager()
    let globalDesign = GlobalDesign()
    
    let menuItemLabels = ["My Account","Recent Requests","My Locations","Payment Settings","Support","Give Feedback","Terms of Use"]
    let menuItemIcons = ["user","clock","markerwhite","credit","people","star","pencil"]
    
    // MARK: Outlets and actions
    @IBAction func logout(_ sender: Any) {
       self.logout()
    }
    
    @IBAction func LogoutIcon(_ sender: Any) {
        self.logout()
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageOutlet: UIImageView!
    
    @IBOutlet weak var topMenuTableView: UITableView!

    // MARK: Programmer Defined Functions
    func setupUI(){
        self.usernameLabel.text = "@\(self.userAccountManager.getUserName())"
        self.topMenuTableView.backgroundColor = self.globalDesign.lightBlueColor
    }
    
    func logout(){
        defaults.removeObject(forKey: "userEmail")
        defaults.removeObject(forKey: "userLogin")
        defaults.removeObject(forKey: self.apiInfo.userAuthenticationString)
    }
    
    //MARK: TableView Delegate Functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = menuItemLabels[indexPath.row]
        
        switch selection {
        case "My Account":
            print("\(selection) selected")
        default:
            print("\(selection) selected")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HamburgerTopMenuCell = self.topMenuTableView.dequeueReusableCell(withIdentifier: "topMenuCell")! as! HamburgerTopMenuCell
        cell.selectionStyle = .none
        cell.backgroundColor = globalDesign.lightBlueColor
        cell.cellLabel.text = menuItemLabels[indexPath.row]
        
        // Images by name, included in parent bundle
        let image = UIImage(named: self.menuItemIcons[indexPath.row])
        cell.cellIcon.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemLabels.count
    }
    
    // MARK: Default Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        // Setup tableview
        self.topMenuTableView.dataSource = self
        self.topMenuTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

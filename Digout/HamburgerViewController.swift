//
//  HamburgerViewController.swift
//  Digout
//
//  Created by Daniel Burkhardt on 11/6/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    // MARK: Class Variables
    var defaults = UserDefaults.standard
    let apiInfo = APIInfo()
    let userAccountManager = UserAccountManager()
    
    let menuItemLabels = ["My Account","Recent Requests","My Locations","Payment Settings","Support","Give Feedback","Terms of Use"]
    let menuItemIcons = ["user","clock","markerwhite","creditcard","people","feedback","pencilwhite"]
    
    // MARK: Outlets and actions
    @IBAction func logout(_ sender: Any) {
       self.logout()
    }
    
    @IBAction func LogoutIcon(_ sender: Any) {
        self.logout()
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageOutlet: UIImageView!
    
    // MARK: Programmer Defined Functions
    func setupUI(){
        self.usernameLabel.text = "@\(self.userAccountManager.getUserName())"
    }
    
    func logout(){
        defaults.removeObject(forKey: "userEmail")
        defaults.removeObject(forKey: "userLogin")
        defaults.removeObject(forKey: self.apiInfo.userAuthenticationString)
    }
    
    // MARK: Default Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

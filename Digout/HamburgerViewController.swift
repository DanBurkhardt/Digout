//
//  HamburgerViewController.swift
//  Digout
//
//  Created by Daniel Burkhardt on 11/6/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    var defaults = UserDefaults.standard
    let apiInfo = APIInfo()
    
    @IBAction func logout(_ sender: Any) {
        defaults.removeObject(forKey: "userEmail")
        defaults.removeObject(forKey: "userLogin")
        defaults.removeObject(forKey: self.apiInfo.userAuthenticationString)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

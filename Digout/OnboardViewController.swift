//
//  OnboardSecondPageViewController.swift
//  digout
//
//  Created by Daniel Burkhardt on 10/28/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {

    ///MARK: Class variables
    let defaults = UserDefaults.standard
    let apiInfo = APIInfo()
    let  request = URLRequest()


    ///MARK: Programmer defined functions
    
    
    
    
    ///MARK: Default class functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (defaults.object(forKey: self.apiInfo.userAuthenticationString) != nil){
            
            print("USER IS AUTHENTICATED")
            self.performSegue(withIdentifier: "navHome", sender: self)
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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

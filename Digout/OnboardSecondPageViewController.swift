//
//  OnboardSecondPageViewController.swift
//  digout
//
//  Created by Daniel Burkhardt on 10/28/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit

class OnboardSecondPageViewController: UIViewController {

    @IBAction func signupButton(_ sender: AnyObject) {
         self.performSegue(withIdentifier: "navSignupView", sender: self)
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

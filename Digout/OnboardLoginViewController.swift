//
//  OnboardingLoginViewController.swift
//  digout
//
//  Created by Daniel Burkhardt on 10/27/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit

class OnboardLoginViewController: UIViewController {

    ///MARK: Outlets & Actions
    
    @IBOutlet weak var emailInputField: UITextField!
    
    @IBOutlet weak var passwordInputField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBAction func forgotPasswordButton(_ sender: AnyObject) {
        // Returning here during iteration 2
    }
    
    
    @IBAction func doneButton(_ sender: AnyObject) {
        
    }
    
    
    ///MARK: Class Variables
    
    /// Class var for accessing user defaults
    let defaults = UserDefaults.standard
    
    ///MARK: Programmer Defined Functions
    
    
    //TODO: Make function for checking completion
    //TODO: Make function for calling user accounts class for authentication with a completion handler
    //TODO: Add activity indicator "show" function to unhide overlay while processing
    //TODO: Add activity indicator "hide" function to hide overlay after the processing is complete
    
    
    //TODO: Make function for "Login completion" that sets a bool in defaults and perform nav to home viewcontroller
    
    
    
    
    ///MARK: Default Class Functions
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

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
    
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBAction func forgotPasswordButton(_ sender: AnyObject) {
        // Returning here during iteration 2
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func doneButton(_ sender: AnyObject) {
        checkForFieldCompletion()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true) { () -> Void in
            print("dimissed")
        }
    }
    
    ///MARK: Class Variables
    
    /// Class var for accessing user defaults
    let defaults = UserDefaults.standard
    let accountManager = UserAccountManager()
    
    ///MARK: Programmer Defined Functions
    
    
    /// Checks to make sure all fields are complete
    func checkForFieldCompletion(){
        // Checking for completion
        if self.emailField.text == ""{
            modifyErrorMessage(message: "email cannot be blank")
        }else if self.passwordField.text == ""{
            modifyErrorMessage(message: "password field cannot be blank")
        }else{
            // only do so if all fields are filled out
            clearErrorMessage()
            initiateLogin()
        }
        
    }
    
    func modifyErrorMessage(message: String) {
        self.errorMessage.text = message
    }
    
    func clearErrorMessage(){
        self.errorMessage.text = ""
    }
    
    func initiateLogin() {
        
        self.activityIndicator.isHidden = false
        
        // Submit the user profile object
        self.accountManager.authenticateUser(email: emailField.text!, rawPassword: passwordField.text!){ (success) in
            
            print("process has returned for user authentication: \(success)")
            
            if success == true {
                self.activityIndicator.isHidden = true
                self.defaults.set(true, forKey: "userIsAuthenticated")
                
                // This is necessary in order to switch operations back to the main queue
                // had this issue: http://stackoverflow.com/questions/26947608/waituntilalltasksarefinished-error-swift
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "navToHome", sender: self)
                }
            }else{
                self.activityIndicator.isHidden = true
                self.defaults.set(false, forKey: "userIsAuthenticated")
                
                //TODO: check for error code status
            }
        }
    }

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

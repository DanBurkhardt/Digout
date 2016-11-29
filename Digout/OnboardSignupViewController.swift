//
//  OnboardingSignupViewController.swift
//  digout
//
//  Created by Daniel Burkhardt on 10/27/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class OnboardSignupViewController: UIViewController {

    ///MARK: Outlets & Actions
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func doneButton(_ sender: AnyObject) {
        // Start verification and submission chain of events
        checkForFieldCompletion()
    }
    
    ///MARK: Class Variables
    let accountManager = UserAccountManager()
    
    let defaults = UserDefaults.standard
    
    ///MARK: Programmer Defined Functions
    
    /// Checks to make sure all fields are complete
    func checkForFieldCompletion(){
        //TODO: add logic for checking that all fields are filled out
        
        self.activityIndicator.isHidden = false
        
        // Checking for completion
        if self.usernameField.text == ""{
            modifyErrorMessage(message: "username cannot be blank")
        }else if self.emailField.text == ""{
            modifyErrorMessage(message: "email cannot be blank")
        }else if self.passwordField.text == ""{
            modifyErrorMessage(message: "password field cannot be blank")
        }else if self.confirmPasswordField.text == ""{
            modifyErrorMessage(message: "confirm password cannot be blank")
        }else{
            // only do so if all fields are filled out
            comparePasswords()
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.dismiss(animated: true) { () -> Void in
            print("dimissed")
        }
    }
    
    /// Compares passwords for verification
    func comparePasswords(){
        if passwordField.text != confirmPasswordField.text{
            self.modifyErrorMessage(message: "passwords do not match")
        }else{
            makeUserObject()
        }
    }

    /// Uses the `UserAccountManager` class to prepare and submit a user profile object
    func makeUserObject(){
        
        // Submit the user profile object
        self.accountManager.createUserObject(username: usernameField.text!, email: emailField.text!, rawPassword: passwordField.text!){ (success) in
            
            print("process has returned for user account creation, status: \(success)")
            
            if success {
                
                self.activityIndicator.isHidden = true
                
                // This is necessary in order to switch operations back to the main queue
                // had this issue: http://stackoverflow.com/questions/26947608/waituntilalltasksarefinished-error-swift
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "navToHome", sender: self)
                }
                
            }else if !(success){
                
                self.activityIndicator.isHidden = true
                
                let errorData: JSON = self.accountManager.errorData
                let message = errorData["message"].string
                self.errorMessage.text = message
                
                
            }
        }
    }
    
    
    func modifyErrorMessage(message: String) {
        self.errorMessage.text = message
    }
    
    func clearErrorMessage(){
        self.errorMessage.text = ""
    }
    
    
    
    ///MARK: Default Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.performSegue(withIdentifier: "navToHome", sender: self)
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

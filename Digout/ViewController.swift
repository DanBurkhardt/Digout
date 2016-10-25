//
//  ViewController.swift
//  Digout
//
//  Created by Daniel Burkhardt on 2/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit



/// Global Variable for User Defaults
let defaults = UserDefaults.standard
/// Global Styles
let styles = GlobalDefaults.styles()
/// Global Defaults
let settings = GlobalDefaults()
/// Global object for API data
let apis = APIInfo()
/// Global var for storing mapping data
let lMapData = LocalMappingData()

class ViewController: UIViewController {

    
    // MARK: Class Variables
    
    /// Bool that holds the login status of the user
    var userLoggedIn = false
    ///
    var dict : NSMutableDictionary!
    /// Var for the last selected user option
    var lastTouchedOption = String()
    /// Facebook login button
    //let loginView : FBSDKLoginButton = FBSDKLoginButton()
    /// URL Request
    //let request = URLRequest()
    /// User Object Model
    var userObject = NSMutableDictionary()
    
    


    // MARK: UI Object Outlets and Actions
    

    @IBOutlet weak var loginMessage: UILabel!

    @IBOutlet weak var buttonStack: UIStackView!
    
    @IBOutlet weak var heyMessage: UILabel!
    
    @IBAction func returnToMain(_ segue: UIStoryboardSegue) {
        print("back to main vc")
        
    }
    
    @IBAction func settingsButton(_ sender: AnyObject) {
        
        
    }
    
    /// Actions for when the user is requesting help
    @IBAction func requestButton(_ sender: AnyObject) {
        
            // Grab VC obj
            let requestControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "requestVC") as? RequestViewController
            
            // Nav
            //volunteerControllerObj?.modalTransitionStyle = UIModalTransitionStyle.
            
            // Logs event for tap
            //logger.logTapEvent("DensityFeature")
            
            present(requestControllerObj!, animated: true, completion: nil)
        
    }
    
    /// Actions for when the user is volunteering
    @IBAction func volunteerButton(_ sender: AnyObject) {
            
            // Grab VC obj
            let volunteerControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "volunteerVC") as? VolunteerViewController
            
            // Nav
            //volunteerControllerObj?.modalTransitionStyle = UIModalTransitionStyle.
            
            // Logs event for tap
            //logger.logTapEvent("DensityFeature")
            
            present(volunteerControllerObj!, animated: true, completion: nil)
            
    }
    
    
    @IBOutlet weak var buttonStackParent: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Always set to initially hidden
        //self.loginView.hidden = true
        
        // Get user data if it has already been auth'd
        //returnUserData()
        
        // Set bg color
        self.view.backgroundColor = styles.standardBlue
        
        // Set light status bar
        settings.setLightStatusbar()
        
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Programmer Defined Methods
    
    
    //TODO: Remove all legacy FB related fucntions below
    /*
    func setupFBButton(){
    
        // Clip FB button to main view
        //self.view.addSubview(loginView)
        // Get main bounds
        let mainScreen = UIScreen.main.bounds
        // Set the frame size and location of the FB button
        //self.loginView.frame = CGRect(x: (mainScreen.width/2 - self.loginView.frame.width/2), y: (mainScreen.height - loginView.frame.height - 70), width: self.loginView.frame.width, height: self.loginView.frame.height)
        
        //loginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        //loginView.delegate = self
    
    }*/
    
    
    
    func unhideLoginInfo(){
        
        self.buttonStack.isHidden = true
        self.loginMessage.isHidden = false

    }
    
    
    
    func hideLoginInfo(){
        
        self.buttonStack.isHidden = false
        self.loginMessage.isHidden = true
        
    }
    
    
    
    // MARK: Facebook delegate methods
    
    /*
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        postLoginNavProcess()
        hideLoginInfo()
 
        /*
        let cancelled = result.isCancelled
        
        
        if cancelled != true{
            
            // Hide all login items
            hideLoginInfo()
            self.userLoggedIn = true
            
            // Get the user data after authing
            returnUserData()
        
        }else{
            hideLoginInfo()
            print("auth was cancelled by the user")
        }
        
        if ((error) != nil)
        {
            // Process error
            print("There was auth error")
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                
                print("test")
            }
        }*/
    }*/
    
    /*
    func signIntoBackend(){
        
        request.executeRequestFromURL(apis.signInUrl, headerDictionary: self.userObject, requestType: "POST", completion: { (finished) -> Void in
            
            
            if finished == true{
                
                print("sign in was successful")
                
                let result = self.request.retrieveData()
                
                //let dictionary:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(result)! as! NSDictionary
                
                //print(dictionary)
                
                // Process post-auth
                self.postLoginNavProcess()
                
            }else{
                print("signin was not successful")
            }
            
        })
    }*/
    
    /// Function for post-login navigation
    func postLoginNavProcess(){
        
        if lastTouchedOption == "volunteer"{
            
            // Grab VC obj
            let volunteerControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "volunteerVC") as? VolunteerViewController
            
            // Nav options
            //volunteerControllerObj?.modalTransitionStyle = UIModalTransitionStyle.
            
            // Log tap event here
            // logger invocation
            
            // Nav
            present(volunteerControllerObj!, animated: true, completion: nil)
            
        }else if lastTouchedOption == "request"{
            // Grab VC obj
            let requestControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "requestVC") as? RequestViewController
            
            // Nav options
            //volunteerControllerObj?.modalTransitionStyle = UIModalTransitionStyle.
            
            // Log tap event here
            // logger invocation
            
            // Nav
           present(requestControllerObj!, animated: true, completion: nil)
        }else{
            // Nothing
        }
        
    }
    
    
    
    
    //TODO: Remove all legacy FB related fucntions below
    
    /*
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    
    func returnUserData()
    {
        // Check for the Facebook login things
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("User access token: \(FBSDKAccessToken.currentAccessToken().tokenString)")
            
            // Set user login status
            self.userLoggedIn = true
            
            // Request the user profile object from FB Graph search
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result , error) -> Void in
                
                if (error == nil){
                    self.dict = result as! NSMutableDictionary
                    
                    print("User object \(self.dict)")
                    
                    // Store the user object and auth token locally
                    defaults.setObject(self.dict, forKey: "userProfileObject")
                    defaults.setObject(FBSDKAccessToken.currentAccessToken().tokenString, forKey: "userFBToken")
                    
                    var id = self.dict["id"] as! String
                    var email = self.dict["email"] as! String
                    print(id)
                    print(email)
                    var name = self.dict["first_name"] as! String
                    
                    self.heyMessage.text = "welcome back, \(name)!"
                    self.heyMessage.hidden = false
                    
                    // Customize the user Object
                    self.userObject.setValue(id, forKey: "id")
                    self.userObject.setValue(email, forKey: "email")
                    
                    print(self.userObject)
                    
                    // Fire off sign-in request
                    //self.signIntoBackend()
                }
            })
            
        }else{
            
            // Set user login status
            self.userLoggedIn = false
            
        }
    }*/


}


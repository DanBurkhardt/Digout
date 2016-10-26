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
            //volunteerControllerObj?.modalTransitionStyle = UIModalTransitionStyle.// for custom transition style
            
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
    
    func unhideLoginInfo(){
        
        self.buttonStack.isHidden = true
        self.loginMessage.isHidden = false

    }
    
    
    
    func hideLoginInfo(){
        
        self.buttonStack.isHidden = false
        self.loginMessage.isHidden = true
        
    }
    
    
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
    

}


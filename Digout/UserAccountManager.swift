//
//  UserAccountManager.swift
//  digout
//
//  Created by Daniel Burkhardt on 10/28/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import SwiftyJSON
import AdSupport

class UserAccountManager {
    
    //MARK: Class variables
    let apiInfo = APIInfo()
    let request = URLRequest()
    let defaults = UserDefaults.standard
    let utilities = Utilities()

    
    //MARK: Functions concerning new user signups and login a user into the system
    ///Function for creating the user profile object
    func createUserObject(username: String, email: String, rawPassword: String, completion: @escaping (_ success: Bool) -> Void){
        
        // Empty JSON object
        var userProfileObject: JSON = [:]
        
        // Initial object fields
        userProfileObject["username"].string = username
        userProfileObject["email"].string = email
        
        // Get and set the passhash
        let passhash = rawPassword.sha256()
        userProfileObject["passhash"].string = passhash
        
        
        // Add the advertising identifier to the profile object
        let myIDFA: String?
        // Check if Advertising Tracking is Enabled
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            // Set the IDFA
            myIDFA = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            
            //Set the IDFA on the object
            userProfileObject["idfa"].string = myIDFA
            
        } else {
            // Set an empty string in the event that it is disabled
            userProfileObject["idfa"].string  = ""
        }
        
        // Add timestamp
        userProfileObject["timestamp"].double = utilities.getEpochTime()
        
        // posts the user profile object to the server
        self.request.postRequest(apiInfo.accountsURL, JSON: userProfileObject) { (success) in
            print("posting user profile object")
            completion(success)
        }
    }//END CREATE USER FUNCTION
    
    ///Function for logging in a user
    func authenticateUser(email: String, rawPassword: String, completion: @escaping (_ success: Bool) -> Void){
        
        // Empty JSON object
        var userLoginObject: JSON = [:]
        
        // Initial object fields
        userLoginObject["email"].string = email
        
        // Get and set the passhash
        let passhash = rawPassword.sha256()
        userLoginObject["passhash"].string = passhash
        
        // Add timestamp
        userLoginObject["timestamp"].double = utilities.getEpochTime()
        
        // Attempts to authenticate the user
        self.request.getRequest(apiInfo.accountsURL, JSON: userLoginObject) { (success) in
            print("attempting to authenticate user")
            if success == true{
                // Store in defaults
                self.storeUserLogin(email: email, passhash: passhash)
                
                // Complete the entire process by returning a bool to the parent function
                completion(true)
            }else{
                // Error should have been displayed or passed in another way
                // Return the status
                completion(false)
            }
        }
    }//END USER AUTHENTICATION FUNCTION
    
    ///Function for reauthenticating the saved user (if the login token expires)
    func reauthenticateUser(completion: @escaping (_ success: Bool) -> Void) {
        let savedUserLogin = self.getUserLogin()
        
        // Empty JSON object
        var userLoginObject: JSON = [:]
        
        // Initial object fields
        userLoginObject["email"].string = savedUserLogin["email"]
        userLoginObject["passhash"].string = savedUserLogin["passhash"]
        userLoginObject["timestamp"].double = utilities.getEpochTime()
        
        // Attempts to reauthenticate the user
        self.request.getRequest(apiInfo.accountsURL, JSON: userLoginObject) { (success) in
            print("attempting to reauthenticate user")
            completion(success)
        }
    }//END USER REAUTHENTICATION FUNCTION
    
    
    //MARK: Functions for interacting with the local system
    
    ///Function for storing the user profile object locally
    func storeUserLogin(email: String, passhash: String){
        // Create and store dictionary of user login details
        let userLogin = ["email": email, "passhash": passhash]
        defaults.set(userLogin, forKey: "userLogin")
        
        // Also add a bool locally to enable the user to cache login status
        defaults.set(true, forKey: "userIsLoggedIn")
    }
    
    
    ///Function for retriving the user profile object locally
    func getUserLogin() -> [String:String] {
        return defaults.object(forKey: "userLogin") as! [String:String]
    }


    
    /* Noted after our team planning meeting on 10/1
     Signup Object contents
     username
     email
     passhash
     timestamp (epoch)
     idfa (advertising ID)
     
     Signin Object
     email
     passhash
     timestamp (epoch)
     
     */

}

extension String {
    
    func sha256() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined(separator: "")
    }
}

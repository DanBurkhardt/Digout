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

    
    //MARK: Functions concerning new user signups and loggin a user into the system
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
        
        //TODO: Set the "timestamp" field on the object
        
        // posts the user profile object to the server
        self.request.postRequest(apiInfo.accountsURL, JSON: userProfileObject) { (success) in
            print("posting user profile object")
            if success == true{
                // Store in defaults
                self.storeUserProfileObject(username: username, data: userProfileObject)
                
                // Complete the etire process by returning a bool to the parent function
                completion(true)
            }else{
                self.storeUserProfileObject(username: username, data: userProfileObject)
                // Error should have been displayed or passed in another way
                // Return the status
                completion(false)
            }
        }
    }//END CREATE USER FUNCTION
    
    
    //TODO: Bayard - Create function for loggin the user into the system
    
    
    //MARK: Functions for interacting with the local system
    
    ///Function for storing the user profile object locally
    func storeUserProfileObject(username: String, data: JSON){
        
        var rawData = Data()
        do{
            let rawJSONData = try data.rawData()
            rawData = rawJSONData
        }catch{
            print("There was no ability to convert from JSON object to raw datatype")
        }
        
        defaults.set(rawData, forKey: username)
        defaults.set(data["username"].string, forKey: "username")
        
        // Also add a bool locally to enable the user to cache login status
        defaults.set(true, forKey: "userIsLoggedIn")
    }
    
    
    ///Function for retriving the user profile object locally
    func getLocalProfileObject() -> JSON {
        
        // Pull stored username as a key for data
        let username = defaults.object(forKey: "username") as! String

        // Grab data
        let rawData = defaults.object(forKey: username) as! Data
        let userObject: JSON = JSON(data: rawData)
        
        return userObject
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

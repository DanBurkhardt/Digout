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
    func createUserObject(username: String, email: String, rawPassword: String, completion: (_ success: Bool) -> Void){
        
        // Empty JSON object
        var userProfileObject: JSON = [:]
        
        // Initial object fields
        userProfileObject["username"].string = username
        userProfileObject["email"].string = email
        
        // Get and set the passhash
        var passhash = rawPassword.sha256()
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
            
            if success == true{
                // Store in defaults
                storeUserProfileObject(username: username, data: userProfileObject)
                
                // Complete the etire process by returning a bool to the parent function
                completion(true)
            }else{
                // Error should have been displayed or passed in another way
                // Return the status
                completion(false)
            }
        }
    }//END CREATE USER FUNCTION
    
    
    
    
    
    //MARK: Functions for interacting with the local system
    
    ///Function for storing the user profile object locally
    func storeUserProfileObject(username: String, data: JSON){
        
        defaults.set(data, forKey: username)
    }
    
    
    ///Function for retriving the user profile object locally
    func getLocalProfileObject(username: String) -> JSON {
        let userObject: JSON = defaults.object(forKey: username) as! JSON
        
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
     fb_id
     
     Request object format
     account_id
     timestamp (epoch)
     difficulty_rating
     request_locations (array of long lat pairs)
     username
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

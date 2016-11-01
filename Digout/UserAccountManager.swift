//
//  UserAccountManager.swift
//  digout
//
//  Created by Daniel Burkhardt on 10/28/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserAccountManager {
    
    //MARK: Functions here to check if a user exists in the system
    
    //TODO: Add function to check if a user exists
    
    
    
    //MARK: Functions concerning new user signups

    //TODO: Add function for creating the user profile object
    func createUserObject(username: String, email: String, rawPassword: String){
        
        // Empty JSON object
        var userProfileObject: JSON = [:]
        
        userProfileObject["username"].string = username
        userProfileObject["email"].string = email
        
        
        var passhash = rawPassword.sha256()
        
        userProfileObject["passhash"].string = passhash
        
        
        print(userProfileObject)
        
       // RESUME HERE
    }
    
    /*
    func hashPassword() -> String {
        
        //TODO: Add password hashing function here
    }*/
    
    //TODO: Add function here for storing a new user on remote server
    
    
    
    //MARK: Functions concerning logging an existing user into the system
    
    //TODO: Retrieve user profile object
    
    
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

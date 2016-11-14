//
//  RequestFetcher.swift
//  digout
//
//  Created by Bayard on 10/26/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire

class URLRequest {
    
    let defaults = UserDefaults.standard
    
    /// A generic function that takes a URL and a SwiftyJSON object, executing a GET request on that oject
    func getRequest(_ url: String, JSON: JSON, completion: @escaping (_ success: Bool) -> Void) {
        print("get request")
        
        Alamofire.request(url, method: .get, parameters: JSON.dictionary).responseJSON { response in
            
            //TODO: build the ability to check for error code
            //TODO: return a boolean status based on the error code
            //print(response.response)
            
            let string = response.description
            print(string)
            
            
            print(response.data)
            
            if let JSON = response.result.value {
                //print("JSON: \(JSON)")
                
                // Set the type as Data and store locally
                self.defaults.set(response.result.value, forKey: "responseData")
            }
            
            
            // Edit this to complete for both conditions
            completion(false)
        }
    }
    
    /// A generic function that takes a URL and a SwiftyJSON object, executing a POST request on that oject
    func postRequest(_ url: String, JSON: JSON, completion: @escaping (_ success: Bool) -> Void) {
        print("post request")
        
        Alamofire.request(url, method: .post, parameters: JSON.dictionary).responseJSON { response in
            
            //TODO: build the ability to check for error code
            //TODO: return a boolean status based on the error code
            print(response.response)
            let string = response.description
            print("response: \(string)")
            print(response.data)
            
            // Edit this to complete for both conditions
            completion(false)
            // Returns false for now becuase the backend is not complete. Once implemented we'll have to build some error code checking into this
        }
        
        
    }
    


}

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

class URLRequest {
    
    var apiInfo = APIInfo()
    
    /// A generic function that takes a URL and a SwiftyJSON object, executing a GET request on that oject
    func getRequest(_ url: String, JSON: JSON, completion: (_ success: Bool) -> Void) {
        
        Alamofire.request(url, method: .get, parameters: JSON.dictionary).responseJSON { response in
            
            //TODO: build the ability to check for error code
            //TODO: return a boolean status based on the error code
            print(response.response)
            print(response.data)
        
        }
    }
    
    /// A generic function that takes a URL and a SwiftyJSON object, executing a POST request on that oject
    func postRequest(_ url: String, JSON: JSON, completion: (_ success: Bool) -> Void) {
        
        Alamofire.request(url, method: .post, parameters: JSON.dictionary).responseJSON { response in
            
            //TODO: build the ability to check for error code
            //TODO: return a boolean status based on the error code
            print(response.response)
            print(response.data)
            
            
        }
        
        
    }
    


}

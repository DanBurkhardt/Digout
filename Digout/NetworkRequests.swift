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

class NetworkRequests {
    
    let defaults = UserDefaults.standard
    
    // buckets for holding resulting datas
    var responseData: JSON = [:]
    var errorData: JSON = [:]
    
    /// A generic function that takes a URL and a SwiftyJSON object, executing a GET request on that oject
    func getRequest(_ url: String, data: JSON, completion: @escaping (_ success: Bool) -> Void) {
        print("getting request..")
        
        Alamofire.request(url, method: .get, parameters: data.dictionary).responseJSON { response in
            
            //TODO: build the ability to check for error code
            //TODO: return a boolean status based on the error code
            //print(response.response)
            
            print(response)
            
                
                if let responseValue = response.result.value {
                    
                    var dict = responseValue as! NSDictionary
                    var jsonObj = JSON(dict)
                    
                    // For now, use the indication of a timestamp to check for non-error response
                    //TODO: replace this when jc implements the error code
                    if jsonObj[0]["timestamp"].string != ""{
                        
                        print("get request was successful")
                        // Set the type as Data and store locally
                        self.defaults.set(response.result.value, forKey: "responseData")
                        
                        completion(true)
                    }else{
                        
                        // Print for debugging and return
                        print("get request was not successful")
                        print(response)
                        print(response.result)
                        completion(false)
                    }
                
                }else{
                    
                    print("JSON data could not be found or stored in response")
                    // Edit this to complete for both conditions
                    completion(false)
                }
            
    
            
        }//END ALAMOFIRE TASK
        
    }// END FUNC
    
    /// A generic function that takes a URL and a SwiftyJSON object, executing a POST request on that oject
    func postRequest(_ url: String, JSON: JSON, completion: @escaping (_ success: Bool) -> Void) {
        print("post request")
        
        let params : Parameters = JSON.dictionary!
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            
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
    
    
    func postRequestWithBody(_ url: String, JSON: JSON, completion: @escaping (_ success: Bool) -> Void){
        
        print("posting request with HTTPBody")
        
        let formedURL:NSURL = NSURL(string: url)!
        let session = URLSession.shared
        
        var request = URLRequest.init(url: formedURL as URL)
    
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let paramString = JSON.description
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                print("error posting request")
                print(error)
                
                self.storeErrorData(data: data!)
                
                completion(false)
                return
            }
            
            //Uncomment to see raw server response
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString)
            
            self.storeResponseData(data: data!)
            completion(true)
            
        }
        
        task.resume()
        
        
    }
    
    
    ///MARK: Data Storage and Retrieval Functions
    
    /// Stores a data object locally by wrapping as SwiftyJSON
    func storeResponseData(data: Data){
        self.responseData = JSON(data)
    }
    
    /// Stores an error response object locally by wrapping as SwiftyJSON
    func storeErrorData(data: Data){
        self.errorData = JSON(data)
    }
    
    /// Returns the response from the URL Request
    func getResponseData()->JSON{
        return self.responseData
    }
    
    // Returns the error response
    func getErrorData()->JSON{
        return self.errorData
    }
    


}



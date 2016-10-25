//
//  URLRequest.swift
//  Swift Utilities
//
//  Created by Dan Burkhardt on 9/19/15.
//  Copyright © 2015 Giganom LLC. All rights reserved.
//

import Foundation

class URLRequest {
    
    /// Place for storing the raw response
    fileprivate var requestData = Data()
    
    init(){
        //Something on init
    }
    
    
    /*
    ///Function for URL call with optional dictionary of headers (String:String)?
    ///Passes back a completion value called "finished" which can then be used to block processing until request returns
    ///
    /// - parameter headerDictionary: Optional `NSDictionary()?` param that contains a dictionary of headers for tasks like authorization and other necessary headers for use in an http/https call
    /// - parameter url: `String()` param that is the url/endpoint from which to request data
    /// - parameter requestType: `String()` param that is the url/endpoint from which to request data
    /// - returns: `Bool()`
    func executeRequestFromURL(_ url: String, headerDictionary: NSDictionary?, requestType: String, completion: @escaping (_ finished: Bool) -> Void){
        
        // Create the request objects
        let providedURLAsNSURL = URL(string: url)
        let request = NSMutableURLRequest(url: providedURLAsNSURL!)
        
        // Add the custom method type from passed string
        // TODO: make this a selection from a `struct` instead of a string to be less error prone
        request.httpMethod = requestType
        
        let postData = try! JSONSerialization.data(withJSONObject: headerDictionary!, options: [])
        
        let jsonString = NSString(data: postData, encoding: String.Encoding.utf8.rawValue)! as String
        
        print(jsonString)
        
        let dataString = try? Data(contentsOf: URL(fileURLWithPath: jsonString))
        
        //request.HTTPBody = jsonString
        /*
        // Check to see if the header array was nil
        if headerDictionary != nil {
            // Add all headers to the request
            for (key, value) in headerDictionary!{
                
                request.setValue(value, forKey: key as! String)
            }
        }*/
        
        // Actual asynchronous URL request for remote data
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (response, data, error) -> Void in
            
            // Return the proper code depending on the error status
            if error == nil{
                
                // In the case where no data is recieved
                if data == nil {
                    print("Data response was nil, request successful but no data retrieved")
                    print("\nError recieved during URL request. \nError: \(error)")
                    print("\nResponse: \(response)")
                    completion(finished: false)
                }else{
                    // Set returned data
                    self.requestData = data!
                    // Pass back status
                    completion(finished: true)
                }
                
                // If error with the actual request
            }else{
                print("Error recieved during URL request. Error: \(error)")
                print("\nResponse: \(response)")
                completion(finished: false)
            }
        }
        
    }// END OF REQUEST EXECUTION FUNCTION
    
    
    /// Accessor method for retrieving the raw request data post-success
    ///
    /// - returns: `NSData()`
    func retrieveData() -> Data{
        return requestData
    }
    
    // TODO: Create a method that functions as a debug mode selector that turns on print statements if debug mode is enabled
    */
}

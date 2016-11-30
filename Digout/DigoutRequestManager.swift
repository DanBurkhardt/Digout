//
//  DigoutRequestManager.swift
//  digout
//
//  Created by Daniel Burkhardt on 11/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON
import Alamofire

class DigoutRequestManager{
    
    //MARK: Class variables
    let apiInfo = APIInfo()
    let request = NetworkRequests()
    let defaults = UserDefaults.standard
    let userAcctManager = UserAccountManager()
    let utilities = Utilities()
    
    //MARK: Request submission functions
    
    ///Function for creating and posting a request object
    func createDigoutRequest(locations: [CLLocationCoordinate2D], rating: Int, completion: @escaping (_ success: Bool) -> Void){
        
        // Init empty json object
        var digoutRequestObject: JSON = [:]
        
        // Start forming the object
        let userAcct = userAcctManager.getUserLogin()
        digoutRequestObject["email"].string = userAcct["email"]
        digoutRequestObject["timestamp"].double = utilities.getEpochTime()
        
        
        // Make an empty array of JSON objects
        var coordinateArray = [JSON]()
        // Pull all of the long lat pairs out of the provided array
        for coordinate in locations{
            var object: JSON = [:]
            let long = coordinate.longitude
            let lat = coordinate.latitude
            
            object["long"].double = long
            object["lat"].double = lat
            
            // Append to parent array
            coordinateArray.append(object)
        }
        
        
        digoutRequestObject["request_locations"].arrayObject = coordinateArray
        
        print("Digout request object")
        print(digoutRequestObject.description)
        
        //Post the request
        self.request.postRequestWithBody(apiInfo.digoutRequestURL, postJSON: digoutRequestObject){ (success) in
        
            if success == true{
                completion(true)
            }else{
                
                completion(false)
            }
            
        }
    }
    
    //MARK: Request retrieval functions
    //TODO: Dev a function for retriving the very last request from the backend system
    
    
    /*
     Request object format
     account_id
     timestamp (epoch)--
     difficulty_rating--
     request_locations (array of long lat pairs)--
     username--
     */
    
}



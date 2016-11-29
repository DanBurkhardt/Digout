//
//  LocalMappingData.swift
//  digout
//
//  Created by Dan Burkhardt on 2/6/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

class LocalMappingData {
    
    var requestorPins: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    let request = NetworkRequests()
    let apiData = APIInfo()
    let defaults = UserDefaults.standard
    
    func getPins( completion: @escaping (_ success: Bool) -> Void) {
        var obj: JSON = [:]
        
        obj["email"].string = (defaults.object(forKey: "userEmail") as! String)
        
        self.request.getRequest(apiData.digoutRequestURL, JSON: obj){ (success) in
            
            print("Local mapping get pins: \(success)")
            
            // Use a failing completion for now
            if success == false{
                //print("success was false, fetching")
                let localData = self.defaults.object(forKey: "responseData") as! NSDictionary
                
                // Pass back false completion for now
                completion(false)
            }
            
        }
    }
}

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
        
        // Pull out local email stored and form obj
        obj["email"].string = (defaults.object(forKey: "userEmail") as! String)
        
        // Fire off request
        self.request.getRequest(apiData.digoutRequestURL, data: obj){ (success) in
            
            print("Local mapping get pins success: \(success)")
            
            // Use a failing completion for now
            if success{
                
                let localData = self.defaults.object(forKey: "responseData") as! NSDictionary
                //print(localData)
                
                completion(true)
                
            }else if !success{
                
                
                completion(false)
            }
            
        }
    }
}

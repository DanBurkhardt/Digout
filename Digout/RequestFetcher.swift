//
//  RequestFetcher.swift
//  digout
//
//  Created by Bayard on 10/26/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import Alamofire

var apiURL = "http://digout-py.mybluemix.net/"

class RequestFetcher {
    
    func getRequests() {
        
        let fullURL = "\(apiURL)requests"
        
        Alamofire.request(fullURL).responseJSON { response in
            print(response.response)
            print(response.data)
        }
        
    }

}

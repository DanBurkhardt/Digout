//
//  APIInfo.swift
//  digout
//
//  Created by Dan Burkhardt on 2/6/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation

class APIInfo {
    
    // This is used for all signup/login requests
    // use a "GET" for login and "POST" for signups
    // User object is passed within the body
    var accountsURL = "https://digout-py.mybluemix.net/api/account"
    
    // Endpoint for all request submission and retrieval
    // use a POST for submitting a new request
    // use a GET for retrieving a request
    var digoutRequestURL = "https://digout-py.mybluemix.net/api/request"
    
    var userAuthenticationString = "userIsAuthenticated"
    
    
    }

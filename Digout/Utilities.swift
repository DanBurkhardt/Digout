//
//  Utilities.swift
//  digout
//
//  Created by Daniel Burkhardt on 11/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation

class Utilities {
    
    // epoch getter
    func getEpochTime() -> Double {
        
        let timeInterval = NSDate().timeIntervalSince1970
        
        return timeInterval
    }
    
    
}

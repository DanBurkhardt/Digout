//
//  GlobalDefaults.swift
//  digout
//
//  Created by Dan Burkhardt on 2/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import UIKit

class GlobalDefaults {
    
    
    struct styles {
        
        var standardBlue = UIColor(red: 0.09, green: 0.494, blue: 1, alpha: 1)
        
    }
    
    
    // These functions edit the status bar color theme
    func setLightStatusbar(){
        
        // Set status bar to the light theme
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    func setDarkStatusBar(){
        
        // Set status bar to the dark theme
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    // All of the things
   // var UIBlue = UIColor(red: 0.09, green: 0.494, blue: 1, alpha: 1)
    
}

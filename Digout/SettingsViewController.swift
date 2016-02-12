//
//  SettingsViewController.swift
//  digout
//
//  Created by Daniel Burkhardt on 2/11/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            print("dimissed")
        }

    }
    

}

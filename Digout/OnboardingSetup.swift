//
//  OnboardingSetup.swift
//  digout
//
//  Created by Daniel Burkhardt on 10/27/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import UIKit
import Onboard

class OnboardingSetup {
    
    
    func setupTestConstraints(firstPage: OnboardingContentViewController, testView: UIView) -> [NSLayoutConstraint] {
     
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        let center = NSLayoutConstraint(item: testView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: firstPage.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    
        
        let height = NSLayoutConstraint(item: testView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 100)
        
        let width = NSLayoutConstraint(item: testView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 100)
        
        let topMargin = NSLayoutConstraint(item: testView, attribute: NSLayoutAttribute.topMargin, relatedBy: NSLayoutRelation.equal, toItem: firstPage.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 300)
        
        constraints.append(center)
        constraints.append(height)
        constraints.append(width)
        constraints.append(topMargin)
        
        return constraints
    }
    
    
}

//
//  DigoutLocationsManager.swift
//  Digout
//
//  Created by Daniel Burkhardt on 12/21/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class LocationsManager{
    
    // MARK: Class Variables
    let defaults = UserDefaults.standard
    let globalKeys = GlobalKeys()
    
    // MARK: Storage and Retrieval Functions
    func addNewLocation(locationObject: JSON){
        var existingLocations = self.getStoredLocations()
        
        print("existing locations \(existingLocations)")
        print("location to store \(locationObject)")
        
        if existingLocations != nil{
            print("stored locations was not nil, modifying")
            
            // Append new object to the array and modify source object
            var locationArray = existingLocations!["locations"].arrayValue
            locationArray.append(locationObject)
            existingLocations!["locations"] = JSON(locationArray)
            
            // Overwrite
            self.storeLocations(data: existingLocations!)
        }else{
            var emptyObject = JSON([:])
            emptyObject["locations"] = [locationObject]
            
            // Debugging
            print("object before storage: \(emptyObject)")
            self.storeLocations(data: emptyObject)
        }
    }
    
    // MARK: Stored object modification functions
    
    // TODO: Make a location removal function for removing object at index
    // TODO: Make a function for modifying a particular value of a field within an object @index
    
    
    // MARK: Accessor / Storage Functions
    
    // Get stored locations object
    func getStoredLocations() -> JSON?{
        if let locations = defaults.object(forKey: globalKeys.storedDigoutLocations){
            let locationsData = JSON(locations)
            print("non-nil local locations returned")
            return locationsData
        }else{
            print("stored locations were nil, returned nil")
            return nil
        }
    }
    
    // Overwrite locally stored locations
    func storeLocations(data: JSON){
        print("locations updated locally, new value \(data)")
        self.defaults.set(data.rawValue, forKey: self.globalKeys.storedDigoutLocations)
    }
    
    // Remove by ovewriting with nil
    func deleteStoredLocations(){
        print("all stored locations removed")
        self.defaults.removeObject(forKey: self.globalKeys.storedDigoutLocations)
    }
}

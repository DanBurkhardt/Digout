//
//  RequestViewController.swift
//  digout
//
//  Created by Dan Burkhardt on 2/6/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit
import MapKit
import SWRevealViewController
import SwiftyJSON

class RequestViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: Class outlets and actions
    @IBOutlet weak var mapView: MKMapView!
  
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func pinPlacementFinished(_ sender: AnyObject) {
        
        // Submit the digout request to the backend
        self.triggerRatingDialog()
    }
    
    @IBAction func settings(_ sender: Any) {
        
    }
    
    @IBOutlet weak var settingsOutlet: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelPinPlacement(_ sender: AnyObject) {
        
        // remove all pins except user
        let userLocation = mapView.userLocation
        
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(userLocation)
        
        // clear local array
        self.localPinArray = [CLLocationCoordinate2D]()
        
        self.cancelButton.isHidden = true
        self.finishButton.isHidden = true
    }
    
    @IBAction func getPins(_ sender: Any) {
        self.loadIndicator.isHidden = false
        self.getPins()
        
        // Remove all visible pins on the map
        let pins = self.mapView.annotations
        for pin in pins{
            self.mapView.removeAnnotation(pin)
        }
    }
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    
    //MARK: Class Variables
    var localPinArray = [CLLocationCoordinate2D]()
    var rating = 0
    let requestManager = DigoutRequestManager()
    let styles = GlobalDefaults.styles()
    let lmapData = LocalMappingData()
    let defaults = UserDefaults.standard
    let manager = CLLocationManager()
    
    
    //MARK: Programmer defined functions
    func triggerRatingDialog(){
        let alertController = UIAlertController(title: nil, message: "Please rate the difficulty of your request", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        let rating5 = UIAlertAction(title: "5", style: .default) { (action) in
            self.rating = 5
            self.triggerConfirmationDialog()
        }
        alertController.addAction(rating5)
        
        let rating4 = UIAlertAction(title: "4", style: .default) { (action) in
            self.rating = 4
            self.triggerConfirmationDialog()
        }
        alertController.addAction(rating4)
        
        let rating3 = UIAlertAction(title: "3", style: .default) { (action) in
            self.rating = 3
            self.triggerConfirmationDialog()
        }
        alertController.addAction(rating3)
        
        let rating2 = UIAlertAction(title: "2", style: .default) { (action) in
            self.rating = 2
            self.triggerConfirmationDialog()
        }
        alertController.addAction(rating2)
        
        let rating1 = UIAlertAction(title: "1", style: .default) { (action) in
            self.rating = 1
            self.triggerConfirmationDialog()
        }
        alertController.addAction(rating1)
        
        self.present(alertController, animated: true) {
        }
    }
    
    func triggerConfirmationDialog(){
        let alertController = UIAlertController(title: "Confirm request details:", message: "Crossings: \(localPinArray.count)\nDifficulty: \(rating)", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            self.submitDigoutRequest()
        }
        alertController.addAction(submitAction)
        
        self.present(alertController, animated: true) {
        }
    }
    
    func submitDigoutRequest(){
        
        self.requestManager.createDigoutRequest(locations: localPinArray, rating: rating){ (success) in
            
            if success{
                print("digout request success")
                let alert = UIAlertController(title: "Saved!", message:"Your important crossings have been saved. We will alert you when a volunteer clears your path. Stay warm!", preferredStyle: .alert)
                let action = UIAlertAction(title: "mmk", style: .default) { _ in
                    // Put here any code that you would like to execute when
                    // the user taps that OK button
                }
                alert.addAction(action)
                self.present(alert, animated: true){}
            }else{
                print("digout request failed")
                let alert = UIAlertController(title: "Failed!", message:"Your request could not be processed successfully. Check the logs", preferredStyle: .alert)
                let action = UIAlertAction(title: "mmk", style: .default) { _ in
                    // Put here any code that you would like to execute when
                    // the user taps that OK button 
                }
                alert.addAction(action)
                self.present(alert, animated: true){}
            }
            
        }
    }// END CREATE DIGOUT REQUEST
    
    func setupRevealController(){
        if self.revealViewController() != nil {
            
            self.settingsOutlet.addTarget(self.revealViewController(), action: "revealToggle:", for: UIControlEvents.touchUpInside)
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        
        if gestureRecognizer.state != .began {return}
        
        self.finishButton.isHidden = false
        self.cancelButton.isHidden = false
        
        // Get the pin dropped
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // Push into the local array of pins
        localPinArray.append(touchMapCoordinate)
        
        let annotation = MKPointAnnotation()
        
        //annotation.title = "test"
        
        annotation.coordinate = touchMapCoordinate
        
        mapView.addAnnotation(annotation)
    }
    
    //MARK: Functions for getting and placing pins
    
    func getPins(){
        self.lmapData.getPins { (success) in
            
            if success == true {
                print("pins loaded")
                
                let pins = self.defaults.object(forKey: "responseData") as! NSDictionary
                
                let jsonData = JSON(pins)
                 //print(jsonData)
                
                self.placeMapPins(rawData: jsonData)
                
            }else{
                
                print("pins were not loaded")
            }
        }
    }
    
    func placeMapPins(rawData: JSON){
        
        print("resulting pins:::")
        
        let pins = rawData["results"][0]["request_locations"].arrayValue
        
        print(pins)
        
        var placed = 0
        
        for pin in pins{
            print("Placing map pin")
            
            var locationCoordinate = CLLocationCoordinate2D()
            locationCoordinate.latitude = pin["lat"].double!
            locationCoordinate.longitude = pin["long"].double!

            //annotation.title = "this crossing is clear!"
            
            let annotation = MKPointAnnotation()
            // Add to map annotation
            annotation.coordinate = locationCoordinate
            mapView.addAnnotation(annotation)
            placed += 1
            
            if placed == (pins.count - 1){
                
                // Hide UI elements
                self.cancelButton.isHidden = true
                self.finishButton.isHidden = true
                self.loadIndicator.isHidden = true
                self.cancelButton.isHidden = false
                
                let alert = UIAlertController(title: "Loaded!", message:"Pins last submitted by the user \(rawData["email"].string) have been loaded", preferredStyle: .alert)
                let action = UIAlertAction(title: "mmk", style: .default) { _ in
                    // Put here any code that you would like to execute when
                    // the user taps that OK button
                }
                alert.addAction(action)
                self.present(alert, animated: true){}
            }
        }
    }
    
    
    // MARK: Default Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRevealController()
        self.loadIndicator.isHidden = true
        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        
        
        // Adding to main queue explicitly due to a bug where this did not work
        DispatchQueue.main.async {
            
            self.manager.delegate = self
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            
            var status = CLLocationManager.authorizationStatus()
            if status == .notDetermined || status == .denied || status == .authorizedWhenInUse{
                print("status was not approved for location services")
                
                self.manager.requestAlwaysAuthorization()
                self.manager.startUpdatingLocation()
            }
            
            self.manager.startUpdatingHeading()
            self.manager.startUpdatingLocation()
            
            // Setup Mapview
            self.mapView.delegate = self
            self.mapView.mapType = MKMapType.standard
            self.mapView.showsUserLocation = true
        }

        
        self.view.backgroundColor = styles.standardBlue
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(RequestViewController.handleLongPress(_:)))
        
        longPressGestureRecognizer.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MapView Delegate Methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mapView.showAnnotations([userLocation], animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

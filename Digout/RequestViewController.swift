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
        self.submitDigoutRequest()
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
        
        let pins = self.mapView.annotations
        for pin in pins{
            self.mapView.removeAnnotation(pin)
        }
    }
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    
    //MARK: Class Variables
    let manager = CLLocationManager()
    var localPinArray = [CLLocationCoordinate2D]()
    let requestManager = DigoutRequestManager()
    let styles = GlobalDefaults.styles()
    let lmapData = LocalMappingData()
    let defaults = UserDefaults.standard
    
    
    //MARK: Programmer defined functions
    func submitDigoutRequest(){
        
        self.requestManager.createDigoutRequest(locations: localPinArray, rating: 3){ (success) in
            
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
            
            if success == false {
                print("TEST: pins gotten")
                
                let pins = self.defaults.object(forKey: "responseData") as! NSDictionary
                
                let jsonData = JSON(pins)
                
                self.placeMapPins(rawData: jsonData)
            }
        }
    }
    
    func placeMapPins(rawData: JSON){
        
        let pins = rawData["request_locations"].arrayValue
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

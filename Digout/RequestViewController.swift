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
import QuartzCore

class RequestViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

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
        
        // Remove all visible pins on the map
        let pins = self.mapView.annotations
        for pin in pins{
            self.mapView.removeAnnotation(pin)
        }
    }
    
    @IBAction func hideNavViewButton(_ sender: Any) {
        // This is a temporary way to hide the nav view in order to be able to proceed with testing
        self.navLayoutView.isHidden = true
    }
    
    @IBAction func unhideNavLayoutView(_ sender: Any) {
        self.navLayoutView.isHidden = false
        self.nearbyTableView.reloadData()
    }
    
    
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    /// The main nav layout view
    @IBOutlet weak var navLayoutView: UIView!
    
    @IBOutlet weak var navLayoutTableviewContainer: UIView!
    
    @IBOutlet weak var nearbyTableView: UITableView!
    
    @IBOutlet weak var navLayoutUsernameLabel: UILabel!
    
    @IBOutlet weak var navLayoutOpenRequestLabel: UILabel!
    
    //MARK: Class Variables
    var localPinArray = [CLLocationCoordinate2D]()
    let requestManager = DigoutRequestManager()
    let styles = GlobalDefaults.styles()
    let lmapData = LocalMappingData()
    let defaults = UserDefaults.standard
    let manager = CLLocationManager()
    let globalDesign = GlobalDesign()
    
    // variables for holding loaded request data
    var numberOfRequests = 0
    var nearbyRequests: JSON = [:]
    
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
    
    func setupNavView(){
        // Setup tableview
        self.nearbyTableView.delegate = self
        self.nearbyTableView.dataSource = self
        
        // Customize UI of the nav view
        self.navLayoutView.layer.cornerRadius = 5
        self.navLayoutTableviewContainer.layer.cornerRadius = 5
        self.navLayoutView.layer.masksToBounds = true
        self.navLayoutTableviewContainer.layer.masksToBounds = true
        self.navLayoutView.backgroundColor = globalDesign.lightBlueColor
        
        
        // Setup Gesture recognition
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(navViewDragged(gesture:)))
        self.navLayoutView.addGestureRecognizer(gesture)
        self.navLayoutView.isUserInteractionEnabled = true
        gesture.delegate = self
    }
    
    func loadNearbyRequests(){
        
        // build new function in the future in lmapdata
        // for now, spoof as if the user's requests are the nearby requests
        self.lmapData.getPins { (success) in
            
            if success == true {
                print("nearbyRequests loaded")
                
                let pins = self.defaults.object(forKey: "responseData") as! NSDictionary
                
                self.nearbyRequests = JSON(pins)
                self.numberOfRequests = (self.nearbyRequests["results"].array?.count)!
                self.navLayoutOpenRequestLabel.text = "Open requests: \(String(self.numberOfRequests))"
                
                print("nearby requests JSON: \(self.nearbyRequests)")
                
                self.nearbyTableView.reloadData()
            }else{
                
                print("nearby requests were not loaded")
            }
        }
        
    }
    
    func navViewDragged(gesture: UIPanGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.began || gesture.state == UIGestureRecognizerState.changed {
            
            //let translation = gesture.translation(in: self.view)
            //print(translation)
            
            //var topMargin = (self.view.center.y)
            
            /*
            print("self.view.center.y: \(topMargin)")
            print("view height: \(gesture.view!.frame.height)")
            print("view min y: \(gesture.view!.frame.minY)")
            print("view center y: \(gesture.view!.center.y)")
            print("view height :\(gesture.view!.frame.height)")
            let height = gesture.view!.frame.height
            let halfHeight = height / 2.0
            print("view height half: \(halfHeight)")
            
            
            if(gesture.view!.frame.minY > topMargin) {
                
                gesture.view!.center = CGPoint(x: gesture.view!.center.x, y: gesture.view!.center.y + translation.y)
                
            }else {
                
                gesture.view!.center = CGPoint(x: gesture.view!.center.x, y: topMargin)
            }
            
            // Reset translation point
            gesture.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
            */
        }
        
    }
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: NearbyTableViewCell = self.nearbyTableView.dequeueReusableCell(withIdentifier: "nearbyCell")! as! NearbyTableViewCell
        
        var row = indexPath.row
        
        let requestItem = self.nearbyRequests["results"][row]
        print("request item: \(requestItem)")
        
        // Double check for existance before force casting and presenting to the user
        if let requestUser = requestItem["username"].string{
            let user = requestUser as! String
            cell.requestedByLabel.text = "requested by @\(user)"
            cell.distanceLabel.text = "900ft"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.numberOfRequests
    }
    
    // MARK: Default Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRevealController()
        self.loadIndicator.isHidden = true
        // Do any additional setup after loading the view.
        
        
        // Adding to main queue explicitly due to a bug where this did not work
        DispatchQueue.main.async {
            
            // Setup all mapping frameworks
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
        
        // Setup mapping interaction
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(RequestViewController.handleLongPress(_:)))
        
        longPressGestureRecognizer.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(longPressGestureRecognizer)

        // Setup for the Nav View and TableView
        self.view.backgroundColor = styles.standardBlue
        self.setupNavView()
        self.loadNearbyRequests()
        
        
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

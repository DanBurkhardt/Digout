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
        self.navLayoutView.isHidden = false
        
    }
    
    @IBAction func getPins(_ sender: Any) {
        
        // Remove all visible pins on the map
        let pins = self.mapView.annotations
        for pin in pins{
            self.mapView.removeAnnotation(pin)
        }
        
        self.loadIndicator.isHidden = false
        self.getPins()
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
    var rating = 0
    let requestManager = DigoutRequestManager()
    let styles = GlobalDefaults.styles()
    let lmapData = LocalMappingData()
    let defaults = UserDefaults.standard
    let manager = CLLocationManager()
    let globalDesign = GlobalDesign()
    let utilites = Utilities()
    
    // variables for holding loaded request data
    var numberOfRequests = 0
    var nearbyRequests: JSON = [:]
    var currentRequest: JSON = [:]
    
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
    
    /// Compiles all pins placed on the map along with other gathered other information into a single request
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
        
        // Form the annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        mapView.addAnnotation(annotation)
    }
    
    //MARK: Functions for getting and placing pins
    
    /// Function for retrieving pins from a remote server
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
    
    /// Generic function for displaying any array of pins passed in on the map
    func placeMapPins(rawData: JSON){
        
        print("resulting pins:::")
        
        let pins = rawData["request_locations"].arrayValue
        
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
            }
        }
    }
    
    /// Sets up the main navigation view
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
    
    /// Sets up any user information to be presented in the main UI views
    func setupUserInfo(){
        if let username = self.defaults.object(forKey: "username"){
            self.navLayoutUsernameLabel.text = username as? String
        }
    }
    
    /// Loads all nearby requests upon first opening to present in the tableview
    func loadNearbyRequests(){
        // build new function in the future in lmapdata
        // for now, spoof as if the user's requests are the nearby requests
        self.lmapData.getPins { (success) in
            if success == true {
                print("nearbyRequests loaded")
                let pins = self.defaults.object(forKey: "responseData") as! NSDictionary
                self.nearbyRequests = JSON(pins)
                
                if let reqNumber = self.nearbyRequests["results"].array?.count{
                    self.numberOfRequests = (self.nearbyRequests["results"].array?.count)!
                }else{
                    self.numberOfRequests = 0
                }
                
                self.navLayoutOpenRequestLabel.text = "Open requests: \(String(self.numberOfRequests))"
                print("nearby requests JSON: \(self.nearbyRequests)")
                self.nearbyTableView.reloadData()
            }else{
                print("nearby requests were not loaded")
            }
        }
        
    }
    
    /// Displays the request tapped within the main tableview
    func displayTappedRequest(){
        // Remove all visible pins on the map
        
        let pins = self.mapView.annotations
        for pin in pins{
            self.mapView.removeAnnotation(pin)
        }
        
        self.navLayoutView.isHidden = true
        
        placeMapPins(rawData: self.currentRequest)
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
        var tappedReq = self.nearbyRequests["results"][indexPath.row]
        
        // Grab the current request
        self.currentRequest = tappedReq
        
        // Perform all necessary tasks associated with this request
        self.displayTappedRequest()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: NearbyTableViewCell = self.nearbyTableView.dequeueReusableCell(withIdentifier: "nearbyCell")! as! NearbyTableViewCell
        var row = indexPath.row
        
        let requestItem = self.nearbyRequests["results"][row]
        print("request item: \(requestItem)")
        
        let numberOfItemsInRequest = requestItem["request_locations"].array?.count
        
        // Double check for existance before force casting and presenting to the user
        if let requestUser = requestItem["username"].string{
            let user = requestUser as! String
            cell.requestedByLabel.text = "requested by @\(user)"
            cell.distanceLabel.text = "900ft"
            
            // for now, providing a hard-coded value for the time estimate to completion
            let timeEstimate = (15 * numberOfItemsInRequest!)
            cell.estimatedTimeLabel.text = "Estimated time: \(timeEstimate)mins"
            var status = CLLocationManager.authorizationStatus()
            if status == .denied || status == .notDetermined || status == .authorizedWhenInUse{
                print("user location status could not be determined, not labelling cell")
                cell.distanceLabel.text = ""
                
            }else{
                
                // Use this to compute the user's relative location to the location
                // of the first item in the result array
                let userLocation = self.mapView.userLocation.location
                
                // Convert the raw values of the item
                if let firstItemLat = requestItem["request_locations"][0]["lat"].double{
                    
                    let firstItemLong = requestItem["request_locations"][0]["long"].double
                    
                    var firstItemLocation = CLLocation(latitude: firstItemLat, longitude: firstItemLong!)
                    
                    /*
                    let estDistanceMeters: CLLocationDistance = (userLocation?.distance(from: firstItemLocation))!
                    let estDistanceMiles = estDistanceMeters / 1609.344
                    
                    var estTotalDistance = Int(estDistanceMiles)
                    var totalDistanceType = "mi"
                    
                    if estDistanceMiles < 0.5{
                        let feet = estDistanceMiles * 5280
                        
                        estTotalDistance = Int(feet)
                        totalDistanceType = "ft"
                    }
                    
                    //print("estimated distance between points: \(estTotalDistance)\(totalDistanceType)")
                    cell.distanceLabel.text = "\(estTotalDistance)\(totalDistanceType)"
                    */
                    
                }
            }
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
    
}

//
//  VolunteerViewController.swift
//  digout
//
//  Created by Dan Burkhardt on 2/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    // Class Variables
    let manager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var userLocationUpdated = false
    var lMapData = LocalMappingData()
    var styles = GlobalDefaults.styles()
    var defaults = UserDefaults.standard
    let digoutLocationsManager = LocationsManager()
    var userHasSavedLocations = true
    
    //Digout Location Data Vars
    var numberOfStoredLocations = 0
    var storedLocationsObject = JSON([:])
    
    
    //MARK: UI Object Outlets and Actions
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sidebarButtonOutlet: UIButton!
    @IBOutlet weak var digoutLocationCollectionView: UICollectionView!
    
    // Diaglog UI
    @IBOutlet weak var dialogBlurView: UIView!
    @IBOutlet weak var dialogBackgroundView: UIView!
    @IBOutlet weak var dialogTitleLabel: UILabel!
    @IBOutlet weak var dialogMessageLabel: UILabel!
    @IBOutlet weak var dialogCancelButtonOutlet: UIButton!
    
    @IBOutlet weak var rightDialogImage: UIImageView!
    @IBOutlet weak var rightDialogLabel: UILabel!
    @IBOutlet weak var leftDialogLabel: UILabel!
    @IBOutlet weak var leftDialogImage: UIImageView!
    
    @IBAction func rightDialogButton(_ sender: Any) {
        print("right dialog button")
        
        if self.rightDialogLabel.text == "Request Service" {
            self.setupSecondDialogView()
        }else if rightDialogLabel.text == "Use My Current Location"{
            // Nav to map view here
            print("nav to map view")
            self.cancelWelcomeProcess()
            self.performSegue(withIdentifier: "navLocationVC", sender: self)
        }
    }
    @IBAction func leftDialogButton(_ sender: Any) {
        print("left dialog button")
    }
    @IBAction func dialogCancelButton(_ sender: Any) {
        self.cancelWelcomeProcess()
        self.setupFirstDialogView()
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
        print("navigation unwound to home")
    }
    
    
    
    // MARK: Class setup functions
    func setupRevealController(){
        if self.revealViewController() != nil {
        self.sidebarButtonOutlet.addTarget(self.revealViewController(), action: "revealToggle:", for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    // MARK: Programmer Defined Methods
    func saveUserLocation(_ location: CLLocationCoordinate2D){
        let long = location.longitude
        let lat = location.latitude
        var pair = NSMutableDictionary()
        pair.setValue(long, forKey: "long")
        pair.setValue(lat, forKey: "lat")
        print(pair)
        defaults.set(pair, forKey: "currentUserLocation")
    }
    

    func getStoredDigoutLocations() {
        var storedLocations  = self.digoutLocationsManager.getStoredLocations()
       
        print("Stored locations \(storedLocations)")
        var test = JSON(storedLocations)
        print(test)
        
        if storedLocations != nil{
            self.userHasSavedLocations = true
            
            self.storedLocationsObject = storedLocations!
            self.numberOfStoredLocations = (storedLocations!["locations"].array?.count)!
            // Reload data after getting stored information
            self.digoutLocationCollectionView.reloadData()
        }else{
            self.userHasSavedLocations = false
            print("no locations were stored")
        }
    }
    
    func testStoreLocations(){
        var emptyObject = JSON([:])
        emptyObject["locationDetails"] = JSON([:])
        emptyObject["locationDetails"]["label"] = "Home"
        emptyObject["locationDetails"]["property_ownership"] = "private"
        emptyObject["locationDetails"]["location_type"] = ["multiple","driveway"]
        
        self.digoutLocationsManager.addNewLocation(locationObject: emptyObject)
    }
    
    // MARK: UISetup Functions
    func setupCollectionView(){
        self.digoutLocationCollectionView.dataSource = self
        self.digoutLocationCollectionView.delegate = self
        self.digoutLocationCollectionView.backgroundColor = UIColor.clear
    
        }
    
    func setupMapView(){
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        
        var status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse{
            print("status was not approved for location services")
            self.manager.requestAlwaysAuthorization()
            self.manager.startUpdatingLocation()
        }else if status == .authorizedAlways{
        }
        
        self.manager.startUpdatingHeading()
        self.manager.startUpdatingLocation()
        
        // Setup Mapview
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.standard
        self.mapView.showsUserLocation = true
        self.view.backgroundColor = styles.standardBlue
    }
    
    func setupDialogUI(){
        // Blur view setup
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.dialogBlurView.bounds
        self.dialogBlurView.addSubview(blurEffectView)
        
        // Dialog Box setup
        self.dialogBackgroundView.layer.cornerRadius = 10
        self.dialogBackgroundView.layer.masksToBounds = true
    }
    
    func setupFirstDialogView(){
        self.dialogTitleLabel.text = "Welcome to Digout"
        self.dialogMessageLabel.text = "Are you requesting service, or are you a service provider?"
        self.leftDialogLabel.text = "Service Provider"
        self.rightDialogLabel.text = "Request Service"
        
        self.rightDialogImage.image = UIImage(named: "shovel")
        self.leftDialogImage.image = UIImage(named: "people")
    }

    func setupSecondDialogView(){
        self.dialogTitleLabel.text = "Let's Get Started"
        self.dialogMessageLabel.text = "In order to make a new request, you need to add at least one digout location."
        self.leftDialogLabel.text = "Use Another Location"
        self.rightDialogLabel.text = "Use My Current Location"
        
        self.rightDialogImage.image = UIImage(named: "gps")
        self.leftDialogImage.image = UIImage(named: "map")
    }
    
    // MARK: Dialogue View Functions
    func showWelcomeDialog(){
        // Look at how to animate fading
        UIView.animate(withDuration: 1.0) {
            //self.dialogBlurView.isHidden = false
            self.dialogBackgroundView.isHidden = false
            self.dialogCancelButtonOutlet.isHidden = false
        }
    }
    
    func cancelWelcomeProcess(){
        // Look at how to animate fading
        UIView.animate(withDuration: 1.0) {
            //self.dialogBlurView.isHidden = true
            self.dialogBackgroundView.isHidden = true
            self.dialogCancelButtonOutlet.isHidden = true
            self.setupFirstDialogView()
        }
    }
    
    // MARK: Default Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Setup Functions
        self.setupRevealController()
        self.setupMapView()
        self.setupCollectionView()
        self.setupDialogUI()
        
        // Debugging functions
        //self.testStoreLocations()
        self.digoutLocationsManager.deleteStoredLocations()
        
        // Load all stored locations
        self.getStoredDigoutLocations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: CollectionViewDelegate Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch userHasSavedLocations {
        case false:
            print("user has no saved locations")
            self.showWelcomeDialog()
        default:
            print("Item tapped:")
            print(self.storedLocationsObject["locations"].arrayValue[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.numberOfStoredLocations == 0{
            return 1
        }else{
            return self.numberOfStoredLocations
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DigoutLocationCell = self.digoutLocationCollectionView.dequeueReusableCell(withReuseIdentifier: "digoutLocationCell", for:  indexPath) as! DigoutLocationCell
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        // Size Controls
        let cellSize = 80
        let topMargin = CGFloat(1)
        
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        self.digoutLocationCollectionView.collectionViewLayout = layout
        
        // Set shadow offset and clip the view to a round shape
        cell.layer.cornerRadius = CGFloat(cellSize / 2)
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 3.0, height: 10.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.8
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius: CGFloat(cellSize) / 2).cgPath
        
        // Base the layout on the number of total location items stored locally
        if self.numberOfStoredLocations <= 1 {
            // If there is only one cell in the collection view
            // put it in the middle of the view
            let leftMargin = (self.digoutLocationCollectionView.frame.width / 2) - (CGFloat(cellSize) / 2)
            layout.sectionInset = UIEdgeInsets(top: topMargin, left: leftMargin, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: cellSize, height: cellSize)
            // Set the layout
            self.digoutLocationCollectionView.collectionViewLayout = layout
            
            // Set title for default view
            if self.numberOfStoredLocations == 0 {
                // Set information on the cell
                cell.cellLabel.text = "Digout"
            }else{
                
                // Set information on the cell
                let locationsArray = self.storedLocationsObject["locations"].arrayValue
                let locationLabel = locationsArray[indexPath.row]["locationDetails"]["label"].string
                // Add it to cell
                cell.cellLabel.text = locationLabel
            }
            
            cell.tag = 0
            
            return cell
            
        }else if numberOfStoredLocations == 2 {
            
            // Re configure the UI based on 2 visible cells
            let leftMargin = (self.digoutLocationCollectionView.frame.width / 3) - (CGFloat(cellSize) / 2)
            layout.sectionInset = UIEdgeInsets(top: topMargin, left: leftMargin, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: cellSize, height: cellSize)
            layout.minimumLineSpacing = CGFloat(cellSize)
            
            // Set the layout and scroll direction
            layout.scrollDirection = UICollectionViewScrollDirection.horizontal
            self.digoutLocationCollectionView.collectionViewLayout = layout
            
            // Set information on the cell
            let locationsArray = self.storedLocationsObject["locations"].arrayValue
            let locationLabel = locationsArray[indexPath.row]["locationDetails"]["label"].string
            // Add it to cell
            cell.cellLabel.text = locationLabel
            
            return cell
            
        }else{
            
            // Limit visible cells on the screen to only three by manipulating insets and item spacing
            let itemSquare = CGFloat(cellSize)
            let leftMargin = (self.digoutLocationCollectionView.frame.width / 4) - (itemSquare)
            layout.sectionInset = UIEdgeInsets(top: topMargin, left: leftMargin, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: itemSquare, height: itemSquare)
            layout.minimumLineSpacing = itemSquare
            
            // Set the layout and scroll direction
            layout.scrollDirection = UICollectionViewScrollDirection.horizontal
            self.digoutLocationCollectionView.collectionViewLayout = layout
            
            // Set information on the cell
            let locationsArray = self.storedLocationsObject["locations"].arrayValue
            let locationLabel = locationsArray[indexPath.row]["locationDetails"]["label"].string
            // Add it to cell
            cell.cellLabel.text = locationLabel

            return cell
        }
    }
    

    // MARK: MapView Delegate Methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mapView.showAnnotations([userLocation], animated: true)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("Map load finished")
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("Map rendering finished")
        placeMapPins()
        
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("Stopped location user")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let currentAnnotation = view.annotation
        mapView.removeAnnotation(currentAnnotation!)
        var pointArray = lMapData.requestorPins
        let polyline = MKPolyline(coordinates: &pointArray, count: lMapData.requestorPins.count)
        self.mapView.add(polyline)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if userLocationUpdated == false{
            userLocation = manager.location!.coordinate
            print("locations = \(userLocation.latitude) \(userLocation.longitude)")
            
            // Pass coordinate for saving and set update to true
            saveUserLocation(userLocation)
            userLocationUpdated = true
        }
    }
    
    func placeMapPins(){
        for pin in lMapData.requestorPins{
            let annotation = MKPointAnnotation()
            print("Placing map pin")
            annotation.title = "this crossing is clear!"
            annotation.coordinate = pin
            mapView.addAnnotation(annotation)
        }
    }
    
    //Deprecated: Magic button overlay, keeping code for documentation
    /*
     @IBAction func magicButton(_ sender: AnyObject) {
     
     var pointArray = lMapData.requestorPins
     let polyline = MKPolyline(coordinates: &pointArray, count: lMapData.requestorPins.count)
     self.mapView.add(polyline)
     }*/

    // Deprecated, keeping for documentation
    /*
     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
     var polylineRenderer = MKPolylineRenderer(overlay: overlay)
     polylineRenderer.strokeColor = styles.standardBlue
     polylineRenderer.lineWidth = 5
     return polylineRenderer
     }*/

}

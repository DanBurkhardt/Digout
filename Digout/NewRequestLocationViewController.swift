//
//  NewRequestLocationViewController.swift
//  Digout
//
//  Created by Daniel Burkhardt on 12/22/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class NewRequestLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // Class Variables
    let defaults = UserDefaults.standard
    let manager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var userLocationUpdated = false
    let styles = GlobalDesign()
    
    // Passed Variables From Previous VC
    public var useCurrentLocation = false
    
    // UI Outlets and Actions
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textInputOutlet: UITextField!
    
    @IBAction func cancelNewRequest(_ sender: Any) {
        print("request cancelled")
        self.performSegue(withIdentifier: "unwindToHome", sender: nil)
    }
    
    // MARK: MapView Delegate Methods
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
        self.mapView.mapType = MKMapType.hybrid
        self.mapView.showsUserLocation = true
        
        // Enable by default
        self.enableMapInput()
    }
    
    
    func enableMapInput(){
        // Setup mapping interaction
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewRequestLocationViewController.handleTap(_:)))
        self.mapView.addGestureRecognizer(tapGestureRecognizer)
    }

    
    func handleTap(_ gestureRecognizer : UIGestureRecognizer) {
        print("tap handling")
        
        // Get the pin dropped
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // Form the annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        mapView.addAnnotation(annotation)
    }
    
    func disableMapInput(){
        let recognizers = self.mapView.gestureRecognizers
        for recognizer in recognizers!{
            self.mapView.removeGestureRecognizer(recognizer)
        }
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !userLocationUpdated{
            self.mapView.showAnnotations([userLocation], animated: false)
            // Only do this the first time the user location is updated
            userLocationUpdated = true
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("Map load finished")
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("Map rendering finished")
        //placeMapPins()
        
        if self.useCurrentLocation{
            // Disable manual pin dropping input
            self.disableMapInput()
            
            // Form the annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = self.mapView.userLocation.coordinate
            mapView.addAnnotation(annotation)
            
        }else{
            // enable input by default
            self.textInputOutlet.becomeFirstResponder()
        }
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("Stopped location user")
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        /*
        let currentAnnotation = view.annotation
        mapView.removeAnnotation(currentAnnotation!)
        var pointArray = lMapData.requestorPins
        let polyline = MKPolyline(coordinates: &pointArray, count: lMapData.requestorPins.count)
        self.mapView.add(polyline)*/
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if userLocationUpdated == false{
            userLocation = manager.location!.coordinate
            print("locations = \(userLocation.latitude) \(userLocation.longitude)")
        }
    }
    
    // MARK: Default Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("passed variable: \(self.useCurrentLocation)")
        
        self.setupMapView()
        self.view.backgroundColor = self.styles.lightBlueColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

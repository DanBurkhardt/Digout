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
        self.mapView.mapType = MKMapType.standard
        self.mapView.showsUserLocation = true
        
        // Setup mapping interaction
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewRequestLocationViewController.handleTap(_:)))
        self.mapView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func handleTap(_ gestureRecognizer : UIGestureRecognizer) {
        print("tap handling")
        
        //if gestureRecognizer.state != .began {return}
        
        // Get the pin dropped
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        print("coordinate \(touchMapCoordinate)")
        
        // Form the annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        mapView.addAnnotation(annotation)

    }

    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mapView.showAnnotations([userLocation], animated: false)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("Map load finished")
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("Map rendering finished")
        //placeMapPins()
        
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
            
            // Pass coordinate for saving and set update to true
            //saveUserLocation(userLocation)
            userLocationUpdated = true
        }
    }
    
    // MARK: Default Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMapView()
        self.view.backgroundColor = self.styles.lightBlueColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

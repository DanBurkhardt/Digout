//
//  VolunteerViewController.swift
//  digout
//
//  Created by Dan Burkhardt on 2/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit
import MapKit

class VolunteerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    let manager = CLLocationManager()
    
    var userLocation = CLLocationCoordinate2D()
    
    var userLocationUpdated = false
    
    
    //MARK: UI Obhect Outlets and Actions
    
    @IBAction func magicButton(sender: AnyObject) {
        
        var pointArray = lMapData.requestorPins
        
        var polyline = MKPolyline(coordinates: &pointArray, count: lMapData.requestorPins.count)
        
        self.mapView.addOverlay(polyline)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            print("dimissed")
        }
    }
    
    

    // MARK: Default Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        
        var status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse{
            print("status was not approved for location services")
            
            self.manager.requestAlwaysAuthorization()
            self.manager.startUpdatingLocation()

        }else if status == .AuthorizedAlways{
            
        
            
        }
        
        
        self.manager.startUpdatingHeading()
        self.manager.startUpdatingLocation()
        
        
        // Setup Mapview
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true
        
        
        self.view.backgroundColor = styles.standardBlue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Programmer Defined Methods
    func saveUserLocation(location: CLLocationCoordinate2D){
        
        let long = location.longitude
        let lat = location.latitude

        var pair = NSMutableDictionary()
        
        pair.setValue(long, forKey: "long")
        pair.setValue(lat, forKey: "lat")
        
        print(pair)
        defaults.setObject(pair, forKey: "currentUserLocation")
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        var polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = styles.standardBlue
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
    // MARK: MapView Delegate Methods
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        self.mapView.showAnnotations([userLocation], animated: true)
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        print("Map load finished")
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        print("Map rendering finished")
        placeMapPins()
    }
    
    func mapViewDidStopLocatingUser(mapView: MKMapView) {
        print("Stopped location user")
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        let currentAnnotation = view.annotation
        
        mapView.removeAnnotation(currentAnnotation!)
        
        var pointArray = lMapData.requestorPins
        
        var polyline = MKPolyline(coordinates: &pointArray, count: lMapData.requestorPins.count)
        
        self.mapView.addOverlay(polyline)

    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
            
            var annotation = MKPointAnnotation()
            
            print("Placing map pin")
            annotation.title = "this crossing is clear!"
            
            annotation.coordinate = pin

            mapView.addAnnotation(annotation)
        }
        
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

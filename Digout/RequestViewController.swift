//
//  RequestViewController.swift
//  digout
//
//  Created by Dan Burkhardt on 2/6/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit
import MapKit

class RequestViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    
    var localPinArray = [CLLocationCoordinate2D]()
    
    @IBOutlet weak var mapView: MKMapView!
  
    @IBOutlet weak var finishButton: UIButton!
    @IBAction func pinPlacementFinished(sender: AnyObject) {
        for pin in localPinArray{
            
            lMapData.requestorPins.append(pin)
            
        }
        
        let alert = UIAlertController(title: "Saved!", message:"Your important crossings have been saved. We will alert you when a volunteer clears your path. Stay warm!", preferredStyle: .Alert)
        let action = UIAlertAction(title: "mmk", style: .Default) { _ in
            // Put here any code that you would like to execute when
            // the user taps that OK button (may be empty in your case if that's just
            // an informative alert)
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
        
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelPinPlacement(sender: AnyObject) {
        
        // remove all pins except user
        let userLocation = mapView.userLocation
        
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(userLocation)
        
        // clear local array
        self.localPinArray = [CLLocationCoordinate2D]()
    }
    
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            print("dimissed")
        }
    }
    
    // MARK: Default Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        
        var status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse{
            print("status was not approved for location services")
            
            self.manager.requestAlwaysAuthorization()
            self.manager.startUpdatingLocation()
        }
        
        self.manager.startUpdatingHeading()
        self.manager.startUpdatingLocation()
        
        
        // Setup Mapview
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true

        
        self.view.backgroundColor = styles.standardBlue
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        
        longPressGestureRecognizer.minimumPressDuration = 0.5
        self.mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func handleLongPress(gestureRecognizer : UIGestureRecognizer){
        
        if gestureRecognizer.state != .Began {return}
        
        self.finishButton.hidden = false
        self.cancelButton.hidden = false
        
        // Get the pin dropped
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
        let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
        // Push into the local array of pins
        localPinArray.append(touchMapCoordinate)
        
        let annotation = MKPointAnnotation()
        
        //annotation.title = "test"
        
        annotation.coordinate = touchMapCoordinate
        
        mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MapView Delegate Methods
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
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

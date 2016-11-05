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

    // MARK: Class outlets and actions
    @IBOutlet weak var mapView: MKMapView!
  
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func pinPlacementFinished(_ sender: AnyObject) {
        
        // Submit the digout request to the backend
        self.submitDigoutRequest()
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelPinPlacement(_ sender: AnyObject) {
        
        // remove all pins except user
        let userLocation = mapView.userLocation
        
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotation(userLocation)
        
        // clear local array
        self.localPinArray = [CLLocationCoordinate2D]()
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        
        self.dismiss(animated: true) { () -> Void in
            print("dimissed")
        }
    }
    
    //MARK: Class Variables
    let manager = CLLocationManager()
    var localPinArray = [CLLocationCoordinate2D]()
    var requestManager = DigoutRequestManager()
    
    
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
    
    
    // MARK: Default Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

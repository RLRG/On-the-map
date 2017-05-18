//
//  MapViewController.swift
//  On the map
//
//  Created by Gmv100 on 25/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate {
    
    // MARK: Properties & lifecycle functions
    
    let sharedStudentsData = SharedDataSource.sharedInstance()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Starting ActivityIndicator (UI)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        // Setting the delegate of the map:
        mapView.delegate = self
        
        // Adding the observer for the event of refreshing the data
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsDidUpdateSuccess), name: NSNotification.Name(rawValue: "refreshStudentLocationsSuccessful"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsDidUpdateFailed), name: NSNotification.Name(rawValue: "refreshStudentLocationsFailed"), object: nil)
        
        // Refreshing the student locations
        sharedStudentsData.refreshStudentLocations()
    }

    
    // MARK: Actions
    
    // TODO: Eliminar redundancia en el código de los dos viewControllers (map & list).
    // TODO: Revise the observers of the refresh to check how they behave when we are in any of the screens.
    // TODO: Atenuar el mapa cuando se esté refrescando la información y mostrar/esconder activityIndicator.
    
    @IBAction func doLogout(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        UdacityClient.sharedInstance().logout(){ (success, errorString) in
            
            self.activityIndicator.stopAnimating()
            
            performUIUpdatesOnMain {
                // If the logout is successful, the user will be presented with the login screen again.
                if success {
                    self.completeLogout()
                }
                    //If the logout does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or another error.
                else {
                    ErrorAlertController.displayErrorAlertViewWithMessage(errorString!, caller: self)
                }
            }
        }
    }
    
    func completeLogout() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func postLocation(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PostingViewController") as! PostingViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        sharedStudentsData.refreshStudentLocations()
    }
    
    
    // MARK: Responses for the refresh map event
    
    func studentLocationsDidUpdateSuccess(_ notification:NSNotification) {
        // Stopping ActivityIndicator
        activityIndicator.stopAnimating()
        
        // Update Map Content - Displaying pins on the map.
        displayPinsOnTheMap()
    }
    
    func studentLocationsDidUpdateFailed(_ notification:NSNotification) {
        // Stopping ActivityIndicator
        activityIndicator.stopAnimating()
        let userInfo = notification.userInfo
        if let error = userInfo?["error"] {
            ErrorAlertController.displayErrorAlertViewWithMessage(error as! String, caller: self)
        }
        else{
            ErrorAlertController.displayErrorAlertViewWithMessage("There was an error when updating the student locations", caller: self)
        }
    }
    
    func displayPinsOnTheMap(){
        
        // The "locations" array:
        let locations = sharedStudentsData.studentLocations
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded.
        for studentLocation:StudentLocation in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(studentLocation.latitude)
            let long = CLLocationDegrees(studentLocation.longitude)
    
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            // Here we create the annotation and set its coordinate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
        }
    }

    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.isEnabled = true
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                if UIApplication.shared.canOpenURL(URL(string: toOpen)!) {
                    UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                } else {
                    ErrorAlertController.displayErrorAlertViewWithMessage("There was an error when opening the URL.", caller: self)
                }
            }
        }
    }
}

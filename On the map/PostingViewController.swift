//
//  PostingViewController.swift
//  On the map
//
//  Created by Gmv100 on 25/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostingViewController : UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets & Properties
    
    // Upper part of the view
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var upperLabel: UITextView!
    @IBOutlet weak var urlTextField: UITextField!
    
    // Bottom part of the view
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomGreyView: UIView!
    @IBOutlet weak var bottomButton: UIButton!
    
    // Properties
    var studentLocation = StudentLocation()
    let parseClient = ParseClient.sharedInstance()
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting delagates
        urlTextField.delegate = self
        locationTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Initializing UI
        initializeUI()
    }
    
    // MARK: - UI related
    
    func initializeUI() {
        performUIUpdatesOnMain {
            // Upper part of the view
            self.urlTextField.isHidden = true
            self.upperLabel.isHidden = false
            self.upperView.backgroundColor = UIColor.lightGray
            
            // Bottom part of the view
            self.locationTextField.isHidden = false
            self.locationTextField.attributedPlaceholder = NSAttributedString(string: "Type your location here!",
                                                                   attributes: [NSForegroundColorAttributeName: UIColor.white])
            self.mapView.isHidden = true
            self.bottomGreyView.isHidden = false
            self.bottomGreyView.backgroundColor = UIColor.lightGray
            self.bottomButton.setTitle("Find on the Map", for: UIControlState.normal)
            self.bottomButton.backgroundColor = .white
            self.bottomButton.layer.cornerRadius = 5
            self.bottomButton.layer.borderWidth = 1
            self.bottomButton.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func prepareUIForSubmission() {
        performUIUpdatesOnMain {
            // Upper part of the view
            self.urlTextField.isHidden = false
            self.urlTextField.attributedPlaceholder = NSAttributedString(string: "Type your URL here!",
                                                                              attributes: [NSForegroundColorAttributeName: UIColor.white])
            self.upperLabel.isHidden = true
            self.upperView.backgroundColor = UIColor.blue
            
            // Bottom part of the view
            self.locationTextField.isHidden = true
            self.mapView.isHidden = false
            self.bottomGreyView.isHidden = true
            self.bottomButton.setTitle("Submit", for: UIControlState.normal)
        }
    }
    
    // MARK:  Map related
    
    func addAnnotationAndSetMap() {
        
        ///////// COORDINATES //////////
        let lat = CLLocationDegrees(studentLocation.latitude)
        let long = CLLocationDegrees(studentLocation.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        performUIUpdatesOnMain {
            self.mapView.addAnnotation(annotation)
        }
        
        ///////// ZOOM LEVEL //////////
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(5) , longitudeDelta: CLLocationDegrees(5))
        
        ///////// SET REGION //////////
        let region = MKCoordinateRegion(center: coordinate, span: span)
        performUIUpdatesOnMain{
            self.mapView.setRegion(region, animated: false)
            self.mapView.isUserInteractionEnabled = false
            self.mapView.isScrollEnabled = false
            self.mapView.isZoomEnabled = false
        }
        
    }
    
    // MARK: - UITextField delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bottomButton(_ sender: Any) {
        
        // TODO: Start Loading SPINNER.
        
        // Step 1. Find on the map.
        if bottomButton.titleLabel?.text == "Find on the Map" {
            findOnTheMap()
        }
        // Step 2. Submit.
        else if bottomButton.titleLabel?.text == "Submit" {
            submitStudentLocation()
        }
    }
    
    func findOnTheMap () {
        // TODO: Check if the text of the locationTextField is valid or not.
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!, completionHandler: { (results, error) in
            
            guard error == nil else {
                // TODO: Manage error.
                return
            }
            
            if (!results!.isEmpty){
                // TODO: Stop Loading SPINNER.
                
                let placemark = results![0]
                self.studentLocation.latitude = (placemark.location?.coordinate.latitude)!
                self.studentLocation.longitude = (placemark.location?.coordinate.longitude)!
                
                self.addAnnotationAndSetMap()
                self.prepareUIForSubmission()
                
            } else {
                // TODO: Stop Loading SPINNER.
                // TODO: Manage error.
            }
        })
    }
    
    func submitStudentLocation () {
        
        // TODO: Submit functionality (change UI, etc.).
        parseClient.postStudentLocation(self.studentLocation) { (success, error) in
            
            print("postStudentLocation completionHandler")
            
            // TODO: Stop Loading SPINNER.
        }
    }
}

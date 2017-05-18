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
    
    func addAnnotationAndSetMap(){
        
        // TODO: REMOVE THIS TEST !!!!!!!
        studentLocation.latitude = 41
        studentLocation.longitude = 4
        
        ///////// COORDINATES //////////
        let lat = CLLocationDegrees(studentLocation.latitude)
        let long = CLLocationDegrees(studentLocation.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        ///////// ZOOM LEVEL //////////
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(5) , longitudeDelta: CLLocationDegrees(5))
        
        ///////// SET REGION //////////
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)
        mapView.isUserInteractionEnabled = false
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
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
        
        // Step 1. Find on the map.
        if bottomButton.titleLabel?.text == "Find on the Map" {
            // TODO: Find on the map functionality (change UI, etc.)
            addAnnotationAndSetMap()
            prepareUIForSubmission()
        }
        // Step 2. Submit.
        else if bottomButton.titleLabel?.text == "Submit" {
            // TODO: Submit functionality (change UI, etc.)
        }
    }
}

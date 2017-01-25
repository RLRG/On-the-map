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

class MapViewController : UIViewController {
    
    // MARK: Properties
    
    let sharedStudentsData = SharedDataSource.sharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Start ActivityIndicator (UI)
        
        // Adding the observer for the event of refreshing the data
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsDidUpdateSuccess), name: NSNotification.Name(rawValue: "refreshStudentLocationsSuccessful"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsDidUpdateFailed), name: NSNotification.Name(rawValue: "refreshStudentLocationsFailed"), object: nil)
        
        // Refreshing the student locations
        sharedStudentsData.refreshStudentLocations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Actions
    
    @IBAction func doLogout(_ sender: Any) {
        
        UdacityClient.sharedInstance().logout(){ (success, errorString) in
            
            performUIUpdatesOnMain {
                // If........  TODO: comment !!!!!!!!!!!!!!!!!
                if success {
                    self.completeLogout()
                }
                    //If the logout does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or another error.
                else {
                    self.displayErrorAlertViewWithMessage(errorString!)
                }
            }
        }
    }
    
    func completeLogout() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func postLocation(_ sender: Any) {
        
        // TODO: Present this view modally and not this way.
        let controller = storyboard!.instantiateViewController(withIdentifier: "PostingViewController") as! PostingViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        sharedStudentsData.refreshStudentLocations()
    }
    
    
    // MARK: Responses for the refresh map event
    
    func studentLocationsDidUpdateSuccess() {
        // TODO: Stop ActivityIndicator (UI)
        // TODO: Update Map Content.
    }
    
    func studentLocationsDidUpdateFailed() {
        // TODO: Stop ActivityIndicator (UI)
        displayErrorAlertViewWithMessage("There was an error when updating the student locations")
    }
    
    // MARK: Auxiliary functions
    
    // To present an error alert view
    func displayErrorAlertViewWithMessage (_ errorString: String) {
        
        let alertController = UIAlertController()
        alertController.title = "ERROR"
        alertController.message = errorString
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
    }
    
}

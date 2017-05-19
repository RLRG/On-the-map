//
//  listViewController.swift
//  On the map
//
//  Created by Gmv100 on 25/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

import Foundation
import UIKit

class ListViewController : UIViewController, UITableViewDelegate {
    
    // MARK: Properties & Lifecycle functions
    
    @IBOutlet weak var tableViewList: UITableView!
    let sharedStudentsData = SharedDataSource.sharedInstance()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Starting ActivityIndicator (UI)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        // Setting the delegate and the dataSource of the tableView
        tableViewList.delegate = self
        tableViewList.dataSource = sharedStudentsData
        
        // Refreshing the student locations
        tableViewList.alpha = 0.25
        sharedStudentsData.refreshStudentLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Adding the observers for the event of refreshing the data and posting a new location.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshStudentLocationsSuccessful"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshStudentLocationsFailed"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "studentPostedLocationSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsDidUpdateSuccess), name: NSNotification.Name(rawValue: "refreshStudentLocationsSuccessful"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsDidUpdateFailed), name: NSNotification.Name(rawValue: "refreshStudentLocationsFailed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(studentPostedLocationSuccess), name: NSNotification.Name(rawValue: "studentPostedLocationSuccess"), object: nil)
    }
    
    // MARK: Actions
    
    @IBAction func doLogout(_ sender: Any) {
        
        UdacityClient.sharedInstance().logout(){ (success, errorString) in
            
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
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
            self.tableViewList.alpha = 0.25
            self.sharedStudentsData.refreshStudentLocations()
        }
    }
    
    
    // MARK: Responses for the refresh map event
    
    func studentLocationsDidUpdateSuccess(_ notification:NSNotification) {
        performUIUpdatesOnMain {
            // Update tableView content.
            self.tableViewList.reloadData()
            
            // Stopping ActivityIndicator
            self.tableViewList.alpha = 1
            self.activityIndicator.stopAnimating()
        }
    }
    
    func studentLocationsDidUpdateFailed(_ notification:NSNotification) {
        performUIUpdatesOnMain {
            // Stopping ActivityIndicator
            self.tableViewList.alpha = 1
            self.activityIndicator.stopAnimating()
            let userInfo = notification.userInfo
            if let error = userInfo?["error"] {
                ErrorAlertController.displayErrorAlertViewWithMessage(error as! String, caller: self)
            }
            else{
                ErrorAlertController.displayErrorAlertViewWithMessage("There was an error when updating the student locations", caller: self)
            }
        }
    }
    
    func studentPostedLocationSuccess(_ notification:NSNotification) {
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
            self.tableViewList.alpha = 0.25
            self.sharedStudentsData.refreshStudentLocations()
        }
    }

    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let studentMediaURL = sharedStudentsData.studentLocations[indexPath.row].mediaURL
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let mediaURL = URL(string: studentMediaURL) {
            if UIApplication.shared.canOpenURL(mediaURL) {
                UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
            } else {
                ErrorAlertController.displayErrorAlertViewWithMessage("There was an error when opening the URL.", caller: self)
            }
        }
    }
}

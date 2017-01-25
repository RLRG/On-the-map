//
//  ViewController.swift
//  On the map
//
//  Created by Gmv100 on 24/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: UI elements
    
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    // MARK: Actions
    
    @IBAction func doLogin(_ sender: Any) {
        
        // When the user taps the Login button, the app will attempt to authenticate with Udacity’s servers.
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        // TODO: Check textField values !!
        UdacityClient.sharedInstance().authenticateUser(emailTextView.text!, password: passwordTextView.text!) { (success, errorString) in
            
            self.activityIndicator.stopAnimating()
            
            performUIUpdatesOnMain {
                // If the connection is made and the email and password are good, the app will segue to the Map and Table Tabbed View.
                if success {
                    self.completeLogin()
                }
                // If the login does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or an incorrect email and password.
                else {
                    self.displayErrorAlertViewWithMessage(errorString!)
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        // Clicking on the Sign Up link will open Safari to the Udacity sign-up page: https://www.udacity.com/account/auth#!/signup
        if UIApplication.shared.canOpenURL(URL(string: "https://www.udacity.com/account/auth#!/signup")!) {
            UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
        } else {
            displayErrorAlertViewWithMessage("There was an error when opening the URL.")
        }
    }
    
    // MARK: Configure UI actions
    
    func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "OnTheMapTabController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    // To present an error alert view
    func displayErrorAlertViewWithMessage (_ errorString: String) {
        
        let alertController = UIAlertController()
        alertController.title = "LOGIN ERROR"
        alertController.message = errorString
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion:nil)
    }
    
    
    // Optional (but fun) task: The “Sign in with Facebook” button in the image authenticates with Facebook. Authentication with Facebook may occur through the device’s accounts or through Facebook’s website.

}


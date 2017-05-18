//
//  ViewController.swift
//  On the map
//
//  Created by Gmv100 on 24/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - UI elements
    
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the delegates of the text fields
        emailTextView.delegate = self
        passwordTextView.delegate = self
        
        // Keyboard notifications: adding observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // MARK: - Actions
    
    @IBAction func doLogin(_ sender: Any) {
        
        // When the user taps the Login button, the app will attempt to authenticate with Udacity’s servers.
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        if (emailTextView.text != "" && passwordTextView.text != "")
        {
            UdacityClient.sharedInstance().authenticateUser(emailTextView.text!, password: passwordTextView.text!) { (success, errorString) in
                
                self.activityIndicator.stopAnimating()
                
                performUIUpdatesOnMain {
                    // If the connection is made and the email and password are good, the app will segue to the Map and Table Tabbed View.
                    if success {
                        self.completeLogin()
                    }
                        // If the login does not succeed, the user will be presented with an alert view specifying whether it was a failed network connection, or an incorrect email and password.
                    else {
                        ErrorAlertController.displayErrorAlertViewWithMessage(errorString!, caller: self)
                    }
                }
            }
        }
        else{
            self.activityIndicator.stopAnimating()
            ErrorAlertController.displayErrorAlertViewWithMessage("Please, complete the email and password boxes to login", caller: self)
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        // Clicking on the Sign Up link will open Safari to the Udacity sign-up page: https://www.udacity.com/account/auth#!/signup
        if UIApplication.shared.canOpenURL(URL(string: "https://www.udacity.com/account/auth#!/signup")!) {
            UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [:], completionHandler: nil)
        } else {
            ErrorAlertController.displayErrorAlertViewWithMessage("There was an error when opening the URL.", caller: self)
        }
    }
    
    // MARK: Configure UI actions
    
    func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "OnTheMapTabController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    
    // Optional (but fun) task: The “Sign in with Facebook” button in the image authenticates with Facebook. Authentication with Facebook may occur through the device’s accounts or through Facebook’s website.

    
    // MARK: - UITextField delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    // MARK: - Keyboard events methods
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}


//
//  UdacityClient.swift
//  On the map
//
//  Created by Gmv100 on 24/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

import Foundation

// MARK: - UdacityClient : NSObject

class UdacityClient : NSObject {
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: Properties
    
    // Shared session
    var session = URLSession.shared
    
    
    // MARK: Initializers.
    override init() {
        super.init()
    }
    
    
    // MARK: Authentication method:
    func authenticateUser (_ user: String, password: String, completionHandlerForAuth: @escaping(_ success: Bool, _ errorString: String?) -> Void) {
        
        // TODO: Authenticate user
        print ("TODO: Authenticate user")
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //let parameters = [String:AnyObject]()
        
        /* 2. Make the request */
        //let _ = taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters) { (results, error) in
            
        /* 3. Send the desired value(s) to completion handler */
//        if let error = error {
//            print(error)
//            completionHandlerForToken(false, nil, "Login Failed (Request Token).")
//        } else {
//            if let requestToken = results?[TMDBClient.JSONResponseKeys.RequestToken] as? String {
//                completionHandlerForToken(true, requestToken, nil)
//            } else {
//                print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(results)")
//                completionHandlerForToken(false, nil, "Login Failed (Request Token).")
//            }
//        }
        let success = true
        let errorString:String? = nil
        completionHandlerForAuth(success, errorString)
    }
    
    
    
}

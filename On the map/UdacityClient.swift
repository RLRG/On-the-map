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
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    
    // MARK: Authentication method
    
    func authenticateUser (_ user: String, password: String, completionHandlerForAuth: @escaping(_ success: Bool, _ userKey: String?, _ errorString: String?) -> Void) {
        
        var success = false
        var errorString = ""
        
        let request = NSMutableURLRequest(url: createURLStringWithParameters(nil, withPathExtension: UdacityClient.Methods.session))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"\(UdacityClient.JSONBodyKeys.udacity)\": {\"\(UdacityClient.JSONBodyKeys.username)\": \"\(user)\", \"\(UdacityClient.JSONBodyKeys.password)\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                errorString = "Login failed ! Please, check your network connection and try again."
                completionHandlerForAuth(success, nil, errorString)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorString = "Login failed ! Please, check that your are entering the correct credentials and try again."
                completionHandlerForAuth(success, nil, errorString)
                return
            }
            
            guard let data = data else {
                errorString = "Login failed ! Please, check that your are entering the correct credentials and try again."
                completionHandlerForAuth(success, nil, errorString)
                return
            }
            
            // FOR ALL RESPONSES FROM THE UDACITY API, WE NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE. These characters are used for security purposes.
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            print("The received data in the response is:")
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject] as AnyObject!
            } catch {
                errorString = "Login failed ! Please, check that your are entering the correct credentials and try again."
                completionHandlerForAuth(success, nil, errorString)
                return
            }
            
            // ERROR
            if let _ = parsedResult[JSONResponseKeys.status] as? Int,
                let error = parsedResult[JSONResponseKeys.error] as? String {
                completionHandlerForAuth(success, nil, errorString)
                return
            }
            
            // SUCCESS
            if let account = parsedResult[JSONResponseKeys.account] as? [String:AnyObject],
                let key = account[JSONResponseKeys.userKey] as? String {
                print("User logged in with key = \(key)")
                success = true
                completionHandlerForAuth(success, key, errorString)
                return
            }
            
            // Catch all errors in case there is no success
            errorString = "Login failed ! Please, check that your are entering the correct credentials and your network connection and try again."
            completionHandlerForAuth(success, nil, errorString)
            
        }
        task.resume()
    }
    
    
    // MARK: Logout - Deleting a session
    
    func logout (_ completionHandlerForLogout: @escaping(_ success: Bool, _ errorString: String?) -> Void) {
        
        var success = false
        var errorString = ""
        
        let request = NSMutableURLRequest(url: createURLStringWithParameters(nil, withPathExtension: UdacityClient.Methods.session))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                errorString = (error?.localizedDescription)!
                completionHandlerForLogout(success, errorString)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorString = "Your request returned a status code other than 2xx!"
                completionHandlerForLogout(success, errorString)
                return
            }
            
            guard let data = data else {
                errorString = "No data was returned by the request!"
                completionHandlerForLogout(success, errorString)
                return
            }
            
            // FOR ALL RESPONSES FROM THE UDACITY API, WE NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE. These characters are used for security purposes.
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range) /* subset response data! */
            print("The received data in the response is:")
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject] as AnyObject!
            } catch {
                errorString = "Could not parse the data as JSON"
                completionHandlerForLogout(success, errorString)
                return
            }
            
            // SUCCESS LOGGING OUT
            if let _ = parsedResult[JSONResponseKeys.session] as? [String:AnyObject] {
                print("User logged out successfully")
                success = true
                completionHandlerForLogout(success, nil)
                return
            }
            
            // Catch all errors in case there is no success
            errorString = "Unable to logout"
            completionHandlerForLogout(success, errorString)
        }
        task.resume()
    }
    
    
    // MARK: Auxiliary functions
    
    func createURLStringWithParameters (_ parameters: [String:AnyObject]?, withPathExtension: String?) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if (parameters != nil) {
            for (key, value) in parameters! {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
}

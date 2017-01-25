//
//  ParseClient.swift
//  On the map
//
//  Created by Gmv100 on 24/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

import Foundation

// MARK: - ParseClient : NSObject

class ParseClient : NSObject {
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: Properties
    
    
    // MARK: Initializers.
    override init() {
        super.init()
    }
    
    
    // MARK: GET Student Locations
    
    func getStudentLocations (_ completionHandlerGetStudentLocations: @escaping (_ success: Bool, _ studentLocations: [StudentLocation]?) -> Void) {
        
        // TODO: GetStudentLocations
//        Optional Parameters:
//        limit - (Number) specifies the maximum number of StudentLocation objects to return in the JSON response
//        Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=100
//        skip - (Number) use this parameter with limit to paginate through results
//        Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=200&skip=400
//        order - (String) a comma-separate list of key names that specify the sorted order of the results
//        Prefixing a key name with a negative sign reverses the order (default order is ascending)
//        Example: https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt
        
        
        // TODO: Get a single student location.
        // Required parameters: where - (Parse Query) a SQL-like query allowing you to check if an object value matches some target value
        // Example: https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D
        // the above URL is the escaped form of… https://parse.udacity.com/parse/classes/StudentLocation?where={"uniqueKey":"1234"}

        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
        
        ///////////////////////////////////////////////
        completionHandlerGetStudentLocations(true, nil)
    }
    
    
    // MARK: POST Student Location
    
    func postStudentLocation (_ completionHandlerPostStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // TODO: postStudentLocation.
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()

        ///////////////////////////////////////////////
        completionHandlerPostStudentLocation(true, "")
    }
    
    
    // MARK: PUT - Update Student Location
    
    func updateStudentLocation (_ completionHandlerUpdateStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // TODO: updateStudentLocation.
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
        
        ///////////////////////////////////////////////
        completionHandlerUpdateStudentLocation(true, "")
    }
    
}

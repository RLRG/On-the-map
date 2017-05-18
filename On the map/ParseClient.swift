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
    
    func getStudentLocations (optionalUserKey userKey: String?, _ completionHandlerGetStudentLocations: @escaping (_ success: Bool, _ studentLocations: [StudentLocation]?, _ errorString:String?) -> Void) {

        var success = false
        var studentLocations:[StudentLocation]? = nil
        var errorString:String? = nil
        
        // ------ 
        //Setting the parameters of the request
        // ------
        var parameters:[String:AnyObject] = [String:AnyObject]()
        // Getting a single student location in case the parameter "userKey" is specified in the function.
        //      Required parameters: where - (Parse Query) a SQL-like query allowing you to check if an object value matches some target value
        //      Example: https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D
        //      the above URL is the escaped form of… https://parse.udacity.com/parse/classes/StudentLocation?where={"uniqueKey":"1234"}
        if let userKeyValue = userKey {
            parameters[ParseClient.ParameterKeys.Where] = "{\"\(ParseClient.ParameterKeys.UniqueKey)\":\"\(userKeyValue)\" }" as AnyObject?
        }
        else {
            // GetStudentLocations
            //        Optional Parameters:
            //        limit - (Number) specifies the maximum number of StudentLocation objects to return in the JSON response
            //        Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=100
            //        skip - (Number) use this parameter with limit to paginate through results
            //        Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=200&skip=400
            //        order - (String) a comma-separate list of key names that specify the sorted order of the results
            //        Prefixing a key name with a negative sign reverses the order (default order is ascending)
            //        Example: https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt
            parameters[ParseClient.ParameterKeys.Limit] = 100 as AnyObject
            parameters[ParseClient.ParameterKeys.Order] = "-updatedAt" as AnyObject
        }
        
        let request = NSMutableURLRequest(url: createURLStringWithParameters(parameters, withPathExtension: ParseClient.Methods.StudentLocation))
        request.addValue(ParseClient.Constants.parseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.restApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
           
            guard error == nil else {
                errorString = (error?.localizedDescription)!
                completionHandlerGetStudentLocations(success, studentLocations, errorString)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorString = "Your request returned a status code other than 2xx!"
                completionHandlerGetStudentLocations(success, studentLocations, errorString)
                return
            }
            
            guard let data = data else {
                errorString = "No data was returned by the request!"
                completionHandlerGetStudentLocations(success, studentLocations, errorString)
                return
            }
            
            print("The received data in the response is:")
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject] as AnyObject!
            } catch {
                errorString = "Could not parse the data as JSON"
                completionHandlerGetStudentLocations(success, studentLocations, errorString)
                return
            }
            
            // Managing the response of the request.
            if let results = parsedResult[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                
                guard results.count > 0 else {
                    errorString = "The result of the request getStudentLocations is empty."
                    completionHandlerGetStudentLocations(success, studentLocations, errorString)
                    return
                }
                
                studentLocations = [StudentLocation]()
                for studentLocation in results {
                    
                    var studentLocToAdd:StudentLocation = StudentLocation()
                    
                    studentLocToAdd.objectId = studentLocation[ParseClient.JSONResponseKeys.ObjectID] as? String ?? ""
                    studentLocToAdd.uniqueKey = studentLocation[ParseClient.JSONResponseKeys.UniqueKey] as? String ?? ""
                    studentLocToAdd.firstName = studentLocation[ParseClient.JSONResponseKeys.FirstName] as? String ?? ""
                    studentLocToAdd.lastName = studentLocation[ParseClient.JSONResponseKeys.LastName] as? String ?? ""
                    studentLocToAdd.mapString = studentLocation[ParseClient.JSONResponseKeys.MapString] as? String ?? ""
                    studentLocToAdd.mediaURL = studentLocation[ParseClient.JSONResponseKeys.MediaURL] as? String ?? ""
                    studentLocToAdd.latitude = studentLocation[ParseClient.JSONResponseKeys.Latitude] as? Double ?? 0.0
                    studentLocToAdd.longitude = studentLocation[ParseClient.JSONResponseKeys.Longitude] as? Double ?? 0.0
                    
                    studentLocations?.append(studentLocToAdd)
                }
                
                success = true
                completionHandlerGetStudentLocations(success, studentLocations, errorString)
                return
            }
            
            // Catch all errors in case there is no success
            errorString = "Unable to get student locations"
            completionHandlerGetStudentLocations(success, studentLocations, errorString)
        }
        task.resume()
    }
    
    
    // MARK: POST Student Location
    
    func postStudentLocation (_ studentLocation: StudentLocation, _ completionHandlerPostStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var success = false
        var errorString:String? = nil
        
        let request = NSMutableURLRequest(url: createURLStringWithParameters(nil, withPathExtension: ParseClient.Methods.StudentLocation))
        request.httpMethod = "POST"
        request.addValue(ParseClient.Constants.parseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.restApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"TODO: UniqueKey\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(ParseClient.JSONBodyValues.FirstName)\", \"\(ParseClient.JSONBodyKeys.LastName)\": \"\(ParseClient.JSONBodyValues.LastName)\",\"\(ParseClient.JSONBodyKeys.MapString)\": \"TODO: MapString\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(ParseClient.JSONBodyValues.MediaURL)\",\"\(ParseClient.JSONBodyKeys.Latitude)\": TODO: Latitude, \"\(ParseClient.JSONBodyKeys.Longitude)\": TODO: Longitude}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                errorString = (error?.localizedDescription)!
                completionHandlerPostStudentLocation(success, errorString)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorString = "Your request returned a status code other than 2xx!"
                completionHandlerPostStudentLocation(success, errorString)
                return
            }
            
            guard let data = data else {
                errorString = "No data was returned by the request!"
                completionHandlerPostStudentLocation(success, errorString)
                return
            }
            
            print("The received data in the response is:")
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject] as AnyObject!
            } catch {
                errorString = "Could not parse the data as JSON"
                completionHandlerPostStudentLocation(success, errorString)
                return
            }
            
            // Managing the response of the request --> postStudentLocation
            // Success
            if let _ = parsedResult[JSONResponseKeys.ObjectID] as? String {
                success = true
                completionHandlerPostStudentLocation(success, nil)
                return
            }
            // Failure
            if let error = parsedResult[JSONResponseKeys.Error] as? String {
                completionHandlerPostStudentLocation(success, error)
                return
            }
            
            // Catch all errors in case there is no success
            errorString = "Unable to post student location"
            completionHandlerPostStudentLocation(success, errorString)
        }
        task.resume()
    }
    
    
    // MARK: PUT - Update Student Location
    
    func updateStudentLocationWithObjectID (_ objectID: String, _ completionHandlerUpdateStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var success = false
        var errorString:String? = nil
        
        let request = NSMutableURLRequest(url: createURLStringWithParameters(nil, withPathExtension: "\(ParseClient.Methods.StudentLocation)/\(objectID)"))
        request.httpMethod = "PUT"
        request.addValue(ParseClient.Constants.parseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.restApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"TODO: UniqueKey\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(ParseClient.JSONBodyValues.FirstName)\", \"\(ParseClient.JSONBodyKeys.LastName)\": \"\(ParseClient.JSONBodyValues.LastName)\",\"\(ParseClient.JSONBodyKeys.MapString)\": \"TODO: MapString\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(ParseClient.JSONBodyValues.MediaURL)\",\"\(ParseClient.JSONBodyKeys.Latitude)\": TODO: Latitude, \"\(ParseClient.JSONBodyKeys.Longitude)\": TODO: Longitude}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil else {
                errorString = (error?.localizedDescription)!
                completionHandlerUpdateStudentLocation(success, errorString)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorString = "Your request returned a status code other than 2xx!"
                completionHandlerUpdateStudentLocation(success, errorString)
                return
            }
            
            guard let data = data else {
                errorString = "No data was returned by the request!"
                completionHandlerUpdateStudentLocation(success, errorString)
                return
            }
            
            print("The received data in the response is:")
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult: AnyObject! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject] as AnyObject!
            } catch {
                errorString = "Could not parse the data as JSON"
                completionHandlerUpdateStudentLocation(success, errorString)
                return
            }
            
            // Managing the response of the request --> updateStudentLocation
            // Success
            if let _ = parsedResult[JSONResponseKeys.ObjectID] as? String {
                success = true
                completionHandlerUpdateStudentLocation(success, nil)
                return
            }
            // Failure
            if let error = parsedResult[JSONResponseKeys.Error] as? String {
                completionHandlerUpdateStudentLocation(success, error)
                return
            }
            
            // Catch all errors in case there is no success
            errorString = "Unable to update student location"
            completionHandlerUpdateStudentLocation(success, errorString)
        }
        task.resume()
    }
}


// MARK: Auxiliary functions

func createURLStringWithParameters (_ parameters: [String:AnyObject]?, withPathExtension: String?) -> URL {
    var components = URLComponents()
    components.scheme = ParseClient.Constants.Scheme
    components.host = ParseClient.Constants.Host
    components.path = ParseClient.Constants.Path + (withPathExtension ?? "")
    components.queryItems = [URLQueryItem]()
    
    if (parameters != nil) {
        for (key, value) in parameters! {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
    }
    
    return components.url!
}

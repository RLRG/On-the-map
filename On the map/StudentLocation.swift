//
//  StudentLocation.swift
//  On the map
//
//  Created by Gmv100 on 25/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var objectId:String
    var uniqueKey:String
    var firstName:String
    var lastName:String
    var mapString:String
    var mediaURL:String
    var latitude:Double
    var longitude:Double
    var createdAt:Date
    var updatedAt:Date
    var ACL:String
    
    init () {
        objectId = ""
        uniqueKey = ""
        firstName = ""
        lastName = ""
        mapString = ""
        mediaURL = ""
        latitude = 0.0
        longitude = 0.0
        createdAt = Date()
        updatedAt = Date()
        ACL = ""
    }
    
    init (_ studentLocation: NSDictionary) {
        objectId = studentLocation[ParseClient.JSONResponseKeys.ObjectID] as? String ?? ""
        uniqueKey = studentLocation[ParseClient.JSONResponseKeys.UniqueKey] as? String ?? ""
        firstName = studentLocation[ParseClient.JSONResponseKeys.FirstName] as? String ?? ""
        lastName = studentLocation[ParseClient.JSONResponseKeys.LastName] as? String ?? ""
        mapString = studentLocation[ParseClient.JSONResponseKeys.MapString] as? String ?? ""
        mediaURL = studentLocation[ParseClient.JSONResponseKeys.MediaURL] as? String ?? ""
        latitude = studentLocation[ParseClient.JSONResponseKeys.Latitude] as? Double ?? 0.0
        longitude = studentLocation[ParseClient.JSONResponseKeys.Longitude] as? Double ?? 0.0
        createdAt = Date()
        updatedAt = Date()
        ACL = ""
    }
}

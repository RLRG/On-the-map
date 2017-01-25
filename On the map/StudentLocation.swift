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
    
    // TODO: INIT FUNCTION WITH ALL THE PARAMETERS
    // init ()
    
    
}

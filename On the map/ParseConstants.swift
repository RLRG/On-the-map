//
//  ParseConstants.swift
//  On the map
//
//  Created by Gmv100 on 24/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

// MARK: - ParseClient (Constants)

extension ParseClient {
    
    struct Constants {
        static let Scheme = "https"
        static let Host = "parse.udacity.com"
        static let Path = "/parse/classes"
        
        static let parseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
    
    struct ParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
        static let Where = "where"
        static let UniqueKey = "uniqueKey"
    }
    
    struct ParameterValues {
        static let OneHundred = 100
        static let TwoHundred = 200
        static let MostRecentlyUpdated = "-updatedAt"
        static let MostRecentlyCreated = "-createdAt"
    }
    
    struct HeaderKeys {
        static let AppId = "X-Parse-Application-Id"
        static let APIKey = "X-Parse-REST-API-Key"
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    struct HeaderValues {
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let JSON = "application/json"
    }

    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
    }
    
    struct JSONResponseKeys {
        static let Error = "error"
        static let Results = "results"
        static let ObjectID = "objectId"
        static let UpdatedAt = "updatedAt"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
    }
    
}

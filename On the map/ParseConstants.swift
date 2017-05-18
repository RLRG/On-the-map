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

    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
    }
    
    struct JSONBodyValues {
        static let FirstName = "Rodrigo"
        static let LastName = "López-Romero"
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

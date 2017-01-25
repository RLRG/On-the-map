//
//  UdacityConstants.swift
//  On the map
//
//  Created by Gmv100 on 24/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let session = "/session"
    }
    
    struct JSONBodyKeys {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
    }
    
    struct JSONResponseKeys {
        static let account = "account"
        static let registered = "registered"
        static let session = "session"
        static let id = "id"
        static let expiration = "expiration"
    }

}

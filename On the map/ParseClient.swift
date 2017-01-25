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
}

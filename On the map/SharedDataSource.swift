//
//  OTMDataSource.swift
//  On the map
//
//  Created by Gmv100 on 25/01/2017.
//  Copyright © 2017 GMV. All rights reserved.
//

import Foundation
import UIKit

class SharedDataSource: NSObject, UITableViewDataSource {
    
    
    // MARK: Singleton Instance
    
    class func sharedInstance() -> SharedDataSource {
        struct Singleton {
            static var sharedInstance = SharedDataSource()
        }
        return Singleton.sharedInstance
    }
    
    
    // MARK: Properties
    
    let parseClient = ParseClient.sharedInstance()
    var studentLocations = [StudentLocation]()
    var currentStudent = StudentLocation()
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    func refreshStudentLocations() {
        
        parseClient.getStudentLocations(optionalUserKey: nil) { (success, students, errorString) in
            
            if success {
                self.studentLocations = students!
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshStudentLocationsSuccessful"), object: nil)
            }
            else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshStudentLocationsFailed"), object: nil, userInfo: [ "error" : errorString ?? "Error in refreshStudentLocations"])
            }
        }
    }
    
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OTMTableViewCell") as UITableViewCell?
        let studentLocation = studentLocations[indexPath.item]
        cell?.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        return cell!
    }
}

//
//  Vehicle.swift
//  RAT
//
//  Created by Kirill on 3/29/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import RealmSwift

class Vehicle: Object{
    
    dynamic var id: Int = 0
    dynamic var VIN: String = ""
    dynamic var number: String = ""
    dynamic var brand: String = ""
    dynamic var model: String = ""
    dynamic var year: String = ""
    dynamic var isAuction: Bool = false
    dynamic var owner: Person?
    dynamic var picture: NSData = UIImageJPEGRepresentation((UIImage.init(named: "машина2"))!, 1) as! NSData

    var crashes = LinkingObjects(fromType: Crash.self, property: "vehicle")
    var offers = LinkingObjects(fromType: Offer.self, property: "vehicle")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getActualcrashes() -> [Crash] {
        
        func isActual(object: Crash) -> Bool {
            return object.actual
        }
        
        return crashes.filter(isActual)
    }
    
    func getHistorycrashes() -> [Crash] {
        
        func isHistory(object: Crash) -> Bool {
            return !object.actual
        }
        
        return crashes.filter(isHistory)
    }
}

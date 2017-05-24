//
//  Service.swift
//  RAT
//
//  Created by Kirill on 3/29/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import RealmSwift

class Service: Object {
    
    dynamic var id = 0
    dynamic var address: String = ""
    dynamic var serviceDescription: String = ""
    dynamic var name: String = ""
    dynamic var phone: String = ""
    dynamic var email: String = ""
    //dynamic var longitude: Double = 0.0
    //dynamic var latitude: Double = 0.0
    var reviews = LinkingObjects(fromType: Review.self, property: "service")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

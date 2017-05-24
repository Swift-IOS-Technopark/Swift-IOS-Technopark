//
//  Crash.swift
//  RAT
//
//  Created by Kirill on 3/29/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Crash: Object {
    
    dynamic var id: Int = 0
    dynamic var code: String = ""
    dynamic var fullDescription: String = ""
    dynamic var shortDescription: String = ""
    dynamic var date: String = ""
    dynamic var actual: Bool = true
    dynamic var vehicle: Vehicle?
    //var offers = LinkingObjects(fromType: Offer.self, property: "crash")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

//
//  Offer.swift
//  RAT
//
//  Created by Kirill on 3/29/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import RealmSwift

class Offer: Object {
    
    dynamic var id: Int = 0
    dynamic var price: Int = 0
    dynamic var message: String = ""
    dynamic var date: String = ""
    dynamic var isAvalible: Bool = false
    dynamic var isConfirmed: Bool = false
    dynamic var vehicle: Vehicle?
    dynamic var service: Service?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

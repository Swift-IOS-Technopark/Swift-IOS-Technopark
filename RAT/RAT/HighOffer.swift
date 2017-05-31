//
//  HighOffer.swift
//  RAT
//
//  Created by Алексаndr on 22.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import RealmSwift

class HighOffer: Object {
    
    dynamic var id: Int = 0
    //dynamic var price: Int = 0
    //dynamic var message: String = ""
    dynamic var date: String = ""
    dynamic var isAvalible: Bool = false
    dynamic var isConfirmed: Bool = false
    dynamic var vehicle: Vehicle?
    dynamic var service: Service?
    var lowOffers = LinkingObjects(fromType: LowOffer.self, property: "highOffer")
    override static func primaryKey() -> String? {
        return "id"
    }}

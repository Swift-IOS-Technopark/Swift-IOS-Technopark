//
//  LowOffer.swift
//  RAT
//
//  Created by Алексаndr on 22.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import RealmSwift

class LowOffer: Object {
    
    dynamic var id: Int = 0
    dynamic var price: Int = 0
    dynamic var message: String = ""
    dynamic var date: String = ""
    dynamic var isAvalible: Bool = false
    dynamic var isChosen: Bool = false
    dynamic var crash: Crash?
    dynamic var highOffer: HighOffer?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

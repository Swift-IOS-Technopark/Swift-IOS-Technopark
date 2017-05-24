//
//  Review.swift
//  RAT
//
//  Created by Kirill on 3/29/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import RealmSwift

class Review: Object {
    
    dynamic var id = 0
    dynamic var date: String = ""
    dynamic var text: String = ""
    dynamic var firstname: String = ""
    dynamic var lastname: String = ""
    var service: Service?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

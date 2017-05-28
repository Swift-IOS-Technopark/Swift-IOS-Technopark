//
//  DataBaseHelper.swift
//  RAT
//
//  Created by Kirill on 4/4/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class DataBaseHelper {
    
    static let realm = try! Realm()
    
    class func deleteVehicles(vehicleIds : [Int]){
        let vehicles = DataBaseHelper.getPerson().vehicles
        for vehicle in vehicles{
            let id = vehicle.id
            if !(vehicleIds.contains(id))
            {
                try! realm.write {
                    realm.delete(vehicle)
                }
            }
        }
    }
    
    class func deleteVehicle(vehicle:Vehicle){
        
        try! realm.write {
            realm.delete(vehicle)
        }
        
    }
    
    class func deleteOffers(vehicle:Vehicle,offerIds : [Int]){
        let offers = vehicle.offers
        for offer in offers{
            let id = offer.id
            if !(offerIds.contains(id))
            {
                try! realm.write {
                    realm.delete(offer)
                }
            }
        }
    }
    
    
    class func setVehicle(person: Person, json: JSON)-> Vehicle{
        let id = json["id"].intValue
        if let vehicle = DataBaseHelper.getVehicle(id: id) {
            try! realm.write {
                vehicle.number = json["number"].stringValue
                vehicle.brand = json["brand"].stringValue
                vehicle.VIN = json["VIN"].stringValue
                vehicle.year = json["year"].stringValue
                vehicle.model = json["model"].stringValue
                vehicle.owner = person
            }
            return vehicle
        }
        else {
            let vehicle = Vehicle()
            vehicle.number = json["number"].stringValue
            vehicle.brand = json["brand"].stringValue
            vehicle.VIN = json["VIN"].stringValue
            vehicle.year = json["year"].stringValue
            vehicle.model = json["model"].stringValue
            vehicle.id = id
            vehicle.owner = person
            save(object: vehicle)
            return vehicle
        }
        
    }
        
    class func setVehicle(person: Person, vehicle: Vehicle){
            let vehicle = vehicle
            vehicle.owner = person
            save(object: vehicle)
    }
    
    class func setVehicle( vehicle: Vehicle){
            let vehicle = vehicle
            save(object: vehicle)
    }
    
    class func setVehiclePicture(data: NSData, vehicle: Vehicle){
        try! realm.write {
            let vehicle = vehicle
            vehicle.picture = data
        }
        //save(object: vehicle)
    }
    
    
    class func getPerson() -> Person {
        let predicate = NSPredicate(format: "actual == true")
        return realm.objects(Person.self).filter(predicate).first!
    }
    
    class func getVehicle(id: Int) -> Vehicle? {
        let predicate = NSPredicate(format: "id == \(id)")
        return realm.objects(Vehicle.self).filter(predicate).first!
    }
    
    class func getCrash(id: Int) -> Crash {
        let predicate = NSPredicate(format: "id == \(id)")
        return realm.objects(Crash.self).filter(predicate).first!
    }
    class func clearActualPerson(){
        let persons = realm.objects(Person.self)
        for person in persons {
            try! realm.write {
                person.actual = false
            }
        }
    }
    
    class func setPerson(person: Person, id: Int, email: String, firstname: String, lastname: String, phone: String, actual: Bool){
            person.id = id
            person.email = email
            person.firstname = firstname
            person.lastname = lastname
            person.phone = phone
            person.actual = actual
            save(object: person)
    }
    class func setPerson(person: Person){
        save(object: person)
    }
    
    class func setCrash(vehicle: Vehicle, json: JSON){
        let crash = Crash()
        crash.date = json["date"].stringValue
        crash.shortDescription = json["description__short_description"].stringValue
        crash.fullDescription = json["description__full_description"].stringValue
        crash.code = json["description__code"].stringValue
        crash.id = json["id"].intValue
        crash.actual = json["actual"].boolValue
        crash.vehicle = vehicle
        save(object: crash)
    }
    
    
    
    /*
    class func setOffer(crash: Crash, json: JSON){
        let offer = Offer()
        let service = Service()
        offer.message = json["message"].stringValue
        offer.price = json["price"].intValue
        offer.id = json["id"].intValue
        offer.vehicle = nil
        offer.service = service
        offer.service!.id = json["service_id"].intValue
        offer.service!.name = json["service__name"].stringValue
        save(object: service)
        save(object: offer)
    }
    */
    
    class func setOffer(vehicle: Vehicle, json: JSON){
        let offer = Offer()
        offer.message = json["message"].stringValue
        offer.price = json["price"].intValue
        offer.id = json["id"].intValue
        offer.date = json["date"].stringValue
        offer.vehicle = vehicle
        
        let service = setService(json: json["service"].arrayValue[0])
        /*
        var service:Service = nil
        for jsonService in json["service"].arrayValue[0]{
            service = setService(json: jsonService)
        }
        */
        offer.service = service
        save(object: offer)
    }
    
    //new offer
    
    class func setHighOffer(vehicle: Vehicle, json: JSON){
        let highOffer = HighOffer()
        highOffer.message = json["message"].stringValue
        highOffer.price = json["price"].intValue
        highOffer.id = json["id"].intValue
        highOffer.date = json["date"].stringValue
        highOffer.vehicle = vehicle
        
        save(object: highOffer)
        
        var lowOffers:[LowOffer] = []
        let jsonLowOffers = json["low_offers"].arrayValue
        for jsonLowOffer in jsonLowOffers{
            lowOffers.append(setLowOffer(highOffer: highOffer, json: jsonLowOffer))
        }
        
        let service = setService(json: json["service"].arrayValue[0])
        
        highOffer.service = service
        save(object: highOffer)
    }
    
    class func setLowOffer(highOffer: HighOffer, json: JSON)-> LowOffer{
        let lowOffer = LowOffer()
        lowOffer.message = json["message"].stringValue
        lowOffer.price = json["price"].intValue
        lowOffer.id = json["id"].intValue
        lowOffer.date = json["date"].stringValue
        lowOffer.highOffer=highOffer
        lowOffer.isAvalible = json["is_avalible"].boolValue
        lowOffer.isChosen = json["is_chosen"].boolValue
        lowOffer.crash = getCrash(id: json["crash_id"].intValue)
        save(object: lowOffer)
        return lowOffer
    }
    
    class func setService(json: JSON)->Service{
        let service = Service()
        service.address = json["address"].stringValue
        service.id = json["id"].intValue
        service.name = json["name"].stringValue
        service.phone = json["phone"].stringValue
        service.email = json["email"].stringValue
        service.serviceDescription = json["description"].stringValue
        save(object: service)
        
        let jsonReviews = json["reviews"].arrayValue
        
        var reviews:[Review]=[]
        for jsonReview in jsonReviews{
            reviews.append(setReview(service: service, json: jsonReview))
        }
        
        save(object: service)
        return service
    }
    
    class func setReview(service: Service, json: JSON)->Review{
        let review = Review()
        review.date = json["date"].stringValue
        review.id = json["id"].intValue
        review.text = json["text"].stringValue
        review.firstname = json["firstname"].stringValue
        review.lastname = json["lastname"].stringValue
        review.service = service
        
        save(object: review)
        return review
    }
    
    class func save(object: Object){
        try! realm.write {
            realm.add(object, update: true)
        }
    }
}

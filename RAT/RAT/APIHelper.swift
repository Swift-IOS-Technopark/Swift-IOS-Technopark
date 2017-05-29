//
//  APIHelper.swift
//  RAT
//
//  Created by Kirill on 4/2/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIHelper {
    
    
    static let SERVER_IP="https://bmsturat.herokuapp.com"
    //static let SERVER_IP="http://192.168.1.43:8000"
    
    
    static let SIGNUP_URL = "\(SERVER_IP)/api/signup"
    static let LOGIN_URL = "\(SERVER_IP)/api/signin"
    static let GET_LIST_OF_VEHICLES_URL = "\(SERVER_IP)/api/get_list_of_vehicles"
    static let EDIT_USER_URL = "\(SERVER_IP)/api/edit_user"
    static let ADD_VEHICLE_URL = "\(SERVER_IP)/api/add_vehicle"
    static let EDIT_VEHICLE_URL = "\(SERVER_IP)/api/edit_vehicle"
    static let DELETE_VEHICLE_URL = "\(SERVER_IP)/api/delete_vehicle"
    static let GET_LIST_OF_HISTORY_CRASHES_URL = "\(SERVER_IP)/api/get_list_of_history_crashes"
    static let GET_LIST_OF_ACTUAL_CRASHES_URL = "\(SERVER_IP)/api/get_list_of_actual_crashes"
    static let GET_LIST_OF_OFFERS_URL = "\(SERVER_IP)/api/get_list_of_offers"
    static let GET_SERVICE_URL = "\(SERVER_IP)/api/get_service"
    static let GET_SERVICE_REVIEWS_URL = "\(SERVER_IP)/api/get_service_reviews"
    static let SET_MARKET_MARKER_URL = "\(SERVER_IP)/api/set_market_marker"
    
    
    //hot download
    static let GET_LISTS_OF_VEHICLES_AND_CRASHES = "\(SERVER_IP)/api/get_lists_of_vehicles_and_crashes"
    static let GET_LISTS_OF_OFFERS_AND_SERVICES = "\(SERVER_IP)/api/get_lists_of_offers_and_services"
    static let GET_LISTS_OF_HIGH_LOW_OFFERS_AND_SERVICES = "\(SERVER_IP)/api/get_lists_of_high_low_offers_and_services"
    
    static let OK = 0
    static let ERROR = 1
    
    class func signUpRequest(person: Person) -> Void {
        
        let parameters: Parameters = [
            "email": person.email,
            "password": person.password,
            "firstname": person.firstname,
            "lastname": person.lastname,
            "phone": person.phone
        ]
        
        request(URL: SIGNUP_URL, method: .post, parameters: parameters, onSuccess: signUpOnSuccess, onError: defaultOnError)
        
    }
    
    class func signUpOnSuccess(json: JSON) -> Void {
        print(json)
        let code = json["code"].int!
        if code == OK {
            NotificationCenter.default.post(name: .signUpCallback, object: nil)
        }
    }
    
    class func logInRequest(person: Person) -> Void {

        let parameters: Parameters = [
            "email": person.email,
            "password": person.password
        ]
        
        request(URL: LOGIN_URL, method: .post, parameters: parameters, onSuccess: logInOnSuccess, onError: defaultOnError)

    }
    
    class func logInOnSuccess(json: JSON) -> Void {
        print(json)
        let code = json["code"].int!
        if code == OK {
            let data = json["data"].dictionaryObject
            NotificationCenter.default.post(name: .logInCallback, object: nil, userInfo: data)
        }
    }
    
    
    class func getListOfVehiclesRequest() -> Void {
        
        let person = DataBaseHelper.getPerson()
        
        let parameters: Parameters = [
            "user_id": person.id
        ]
        
        request(URL: GET_LIST_OF_VEHICLES_URL, method: .get, parameters: parameters, onSuccess: getListOfVehiclesOnSuccess, onError: defaultOnError)
    }
    
    class func getListOfVehiclesOnSuccess(json: JSON) -> Void{

        let code = json["code"].int!
        if code == OK {
            let data = json.dictionaryValue
            NotificationCenter.default.post(name: .getVehiclesCallback, object: nil, userInfo: data)
        }
        
    }
    
    class func getListOfActualCrashesRequest(vehicle: Vehicle) -> Void {
        
        let parameters: Parameters = [
            "vehicle_id": vehicle.id
        ]
        
        request(URL: GET_LIST_OF_ACTUAL_CRASHES_URL, method: .get, parameters: parameters, onSuccess: getListOfActualCrashesOnSuccess, onError: defaultOnError)
    }
    
    class func getListOfActualCrashesOnSuccess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            let data = json.dictionaryValue
            NotificationCenter.default.post(name: .getListOfCrashesCallback, object: nil, userInfo: data)
        }
        
    }
    
    class func getListOfHistoryCrashesRequest(vehicle: Vehicle) -> Void {
        
        let parameters: Parameters = [
            "vehicle_id": vehicle.id
        ]
        
        request(URL: GET_LIST_OF_HISTORY_CRASHES_URL, method: .get, parameters: parameters, onSuccess:getListOfHistoryCrashesOnSuccess, onError: defaultOnError)
    }
    
    class func getListOfHistoryCrashesOnSuccess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            let data = json.dictionaryValue
            NotificationCenter.default.post(name: .getListOfCrashesCallback, object: nil, userInfo: data)
        }
        
    }
    
    class func getListOfOffersRequest(crash: Crash) -> Void {
        
        let parameters: Parameters = [
            "crash_id": crash.id
        ]
        
        request(URL: GET_LIST_OF_OFFERS_URL, method: .get, parameters: parameters, onSuccess: getListOfOffersOnSuccess, onError: defaultOnError)
    }
    
    class func getListOfOffersOnSuccess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            let data = json.dictionaryValue
            NotificationCenter.default.post(name: .getListOfOffersCallback, object: nil, userInfo: data)
        }
    }
    
    class func getServiceRequest(offer: Offer) -> Void{
        
        let parameters: Parameters = [
            "service_id": offer.service!.id
        ]
        
        request(URL: GET_SERVICE_URL, method: .get, parameters: parameters, onSuccess: getServiceOnSuccess, onError: defaultOnError)

    }
    
    class func getServiceOnSuccess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            let data = json.dictionaryValue
            NotificationCenter.default.post(name: .getServiceCallback, object: nil, userInfo: data)
        }
    }
    
    class func getListOfReviewsRequest(offer: Offer) -> Void{
        let parameters: Parameters = [
            "service_id": offer.service!.id
        ]
        
        request(URL: GET_SERVICE_REVIEWS_URL, method: .get, parameters: parameters, onSuccess: getListOfReviewsOnSuccess, onError: defaultOnError)

    }
    
    class func getListOfReviewsOnSuccess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            let data = json.dictionaryValue
            NotificationCenter.default.post(name: .getListOfReviewsCallback, object: nil, userInfo: data)
        }
    }
    
    
    /*
    class func editUserRequest() -> Void {
        
        let parameters: Parameters = [
            "user_id": Person.instance.id!,
            "email": Person.instance.email,
            "password": Person.instance.password,
            "firstname": Person.instance.firstname,
            "lastname": Person.instance.lastname,
            "phone": Person.instance.phone
        ]
        
        request(URL: EDIT_USER_URL, method: .post, parameters: parameters, onSuccess: defaultOnSuccess, onError: defaultOnError)
    }

    class func addVehiclesRequest(vehicle: Vehicle) -> Void {
        
        let parameters: Parameters = [
            "user_id": vehicle.id!,
            "VIN": vehicle.VIN,
            "number": vehicle.number,
            "brand": vehicle.brand,
            "model": vehicle.model,
            "year": vehicle.year
        ]
        
        request(URL: ADD_VEHICLE_URL, method: .post, parameters: parameters, onSuccess: defaultOnSuccess, onError: defaultOnError)

    }




    
    class func editVehicleRequest(vehicle: Vehicle) -> Void {
        
        let parameters: Parameters = [
            "user_id": vehicle.id!,
            "VIN": vehicle.VIN,
            "number": vehicle.number,
            "brand": vehicle.brand,
            "model": vehicle.model,
            "year": vehicle.year
        ]
        
        request(URL: EDIT_VEHICLE_URL, method: .post, parameters: parameters, onSuccess: defaultOnSuccess, onError: defaultOnError)
    }
    
    */
    
    class func getListsOfVehiclesAndCrashesRequest() -> Void {
        
        let person = DataBaseHelper.getPerson()
        
        let parameters: Parameters = [
            "user_id": person.id
        ]
        
        request(URL: GET_LISTS_OF_VEHICLES_AND_CRASHES, method: .get, parameters: parameters, onSuccess: getListsOfVehiclesAndCrashesOnSuccess, onError: defaultOnError)
    }
    
    
    class func getListsOfVehiclesAndCrashesOnSuccess(json: JSON) -> Void{
        
        let code = json["code"].int!
        if code == OK {
            let data = json.dictionaryValue
            print(data)
            NotificationCenter.default.post(name: .getListsOfVehiclesAndCrashesCallback, object: nil, userInfo: data)
        }
        
    }

    
    
    class func getListsOfOffersAndServicesRequest(vehicle:Vehicle) -> Void {
        //remake
        let person = DataBaseHelper.getPerson()
        
        let parameters: Parameters = [
            "user_id": person.id,
            "vehicle_id":vehicle.id
        ]
        
        request(URL: GET_LISTS_OF_OFFERS_AND_SERVICES, method: .get, parameters: parameters, onSuccess: getListsOfOffersAndServicesOnSuccess, onError: defaultOnError)
    }
    
    
    class func getListsOfOffersAndServicesOnSuccess(json: JSON) -> Void{
        
        let code = json["code"].int!
        if code == OK {
            let data = json.dictionaryValue
            print(data)
            NotificationCenter.default.post(name: .getListsOfOffersAndServicesCallback, object: nil, userInfo: data)
        }
        
    }
    
    class func getListsOfHighLowOffersAndServicesRequest(vehicle:Vehicle) -> Void {
        //remake
        let person = DataBaseHelper.getPerson()
        
        let parameters: Parameters = [
            "user_id": person.id,
            "vehicle_id":vehicle.id
        ]
        
        request(URL: GET_LISTS_OF_HIGH_LOW_OFFERS_AND_SERVICES, method: .get, parameters: parameters, onSuccess: getListsOfHighLowOffersAndServicesOnSuccess, onError: defaultOnError)
    }
    
    
    class func getListsOfHighLowOffersAndServicesOnSuccess(json: JSON) -> Void{
        
        let code = json["code"].int!
        if code == OK {
            let data = json.dictionaryValue
            print(data)
            NotificationCenter.default.post(name: .getListsOfHighLowOffersAndServicesCallback, object: nil, userInfo: data)
        }
        
    }
    
    
    
    class func setMarketMarkerRequest(vehicle:Vehicle) -> Void {
        let parameters: Parameters = [
            "vehicle_id": vehicle.id,
            "is_auction": vehicle.isAuction
        ]
        
        request(URL: SET_MARKET_MARKER_URL, method: .get, parameters: parameters, onSuccess: setMarketMarkerOnSuccess, onError: defaultOnError)
    }
    
    
    class func setMarketMarkerOnSuccess(json: JSON) -> Void{
        
        let code = json["code"].int!
        if code == OK {
            //let data = json.dictionaryValue
            //print(data)
            //NotificationCenter.default.post(name: .getListsOfOffersAndServicesCallback, object: nil, userInfo: data)
        }
        else{
            //throw eror of network????
        }
        
    }
    
    
    class func addVehiclesRequest(vehicle: Vehicle,user:Person) -> Void {
        
        let parameters: Parameters = [
            "user_id": user.id,
            "VIN": vehicle.VIN,
            "number": vehicle.number,
            "brand": vehicle.brand,
            "model": vehicle.model,
            "year": vehicle.year
        ]
        
        request(URL: ADD_VEHICLE_URL, method: .post, parameters: parameters, onSuccess: addVehiclesOnSucsess, onError: defaultOnError)
        
    }
    
    class func addVehiclesOnSucsess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            let data = json["data"].dictionaryObject
            NotificationCenter.default.post(name: .addVehicleCallback, object: nil,userInfo: data)
        }
        
    }
    
    class func changeVehicleRequest(vehicle: Vehicle) -> Void {
        print("changing vehicle with id=\(vehicle.id)")
        let parameters: Parameters = [
            "vehicle_id":vehicle.id,
            "VIN": vehicle.VIN,
            "number": vehicle.number,
            "brand": vehicle.brand,
            "model": vehicle.model,
            "year": vehicle.year,
            "is_auction": vehicle.isAuction
        ]
        
        request(URL: EDIT_VEHICLE_URL, method: .post, parameters: parameters, onSuccess: changeVehicleOnSucsess, onError: defaultOnError)
        
    }
    
    class func changeVehicleOnSucsess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            NotificationCenter.default.post(name: .changeVehicleCallback, object: nil,userInfo: nil)
        }
        
    }
    
    class func deleteVehicleRequest(vehicle: Vehicle) -> Void {
        
        let parameters: Parameters = [
            "vehicle_id":vehicle.id
        ]
        
        request(URL: DELETE_VEHICLE_URL, method: .post, parameters: parameters, onSuccess: deleteVehicleOnSucsess, onError: defaultOnError)
        
    }
    
    class func deleteVehicleOnSucsess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            NotificationCenter.default.post(name: .deleteVehicleCallback, object: nil,userInfo: nil)
        }
        
    }


    
    class func editUserRequest(user:Person) -> Void {
        
        let parameters: Parameters = [
            "user_id": user.id,
            "email": user.email,
            "password": user.password,
            "firstname": user.firstname,
            "lastname": user.lastname,
            "phone": user.phone
        ]
        
        request(URL: EDIT_USER_URL, method: .post, parameters: parameters, onSuccess: editUserOnSucsess, onError: defaultOnError)
    }
    
    
    
    class func editUserOnSucsess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            
            NotificationCenter.default.post(name: .editUserCallback, object: nil)
        }
        
    }
    
    class func editVehicleRequest(vehicle: Vehicle) -> Void {
        
        let parameters: Parameters = [
            "user_id": vehicle.id,
            "VIN": vehicle.VIN,
            "number": vehicle.number,
            "brand": vehicle.brand,
            "model": vehicle.model,
            "year": vehicle.year
        ]
        
        request(URL: EDIT_VEHICLE_URL, method: .post, parameters: parameters, onSuccess: editVehicleOnSucsess, onError: defaultOnError)
        
    }
    
    
    class func editVehicleOnSucsess(json: JSON) -> Void{
        print(json)
        let code = json["code"].int!
        if code == OK {
            
            NotificationCenter.default.post(name: .editVehicleCallback, object: nil)
        }
        
    }
    
    
    // else code
    
    class func defaultOnSuccess(json: JSON) -> Void{
        print(json)
    }
    
    class func defaultOnError(error: Any) -> Void {
        print(error)
    }
    
    class func request(URL: String, method: HTTPMethod, parameters: Parameters, onSuccess: @escaping (JSON) -> Void , onError: @escaping (Any) -> Void) -> Void {
        Alamofire.request(URL, method: method, parameters: parameters ).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                onSuccess(json)
            case .failure(let error):
                onError(error)
            }
        }
    }

}

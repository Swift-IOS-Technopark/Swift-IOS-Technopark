//
//  ListOfVehiclesViewController.swift
//  RAT
//
//  Created by Kirill on 3/30/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListOfVehiclesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var listOfVehiclesTable: UITableView!
    var person = Person()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfVehiclesTable.dataSource = self
        listOfVehiclesTable.delegate = self
        listOfVehiclesTable.tableFooterView = UIView() // delete excess separators
        NotificationCenter.default.addObserver(self, selector: #selector(getListsOfVehiclesAndCrashesCallback(_:)), name: .getListsOfVehiclesAndCrashesCallback, object: nil)
        person = DataBaseHelper.getPerson()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: #selector(ListOfVehiclesViewController.refresh), for: .valueChanged)
        listOfVehiclesTable.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        APIHelper.getListsOfVehiclesAndCrashesRequest()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfVehiclesTable.dequeueReusableCell(withIdentifier: "VehicleCell") as! VehicleCell
        let index = indexPath.row
        cell.number.text = person.vehicles[index].number
        cell.brand.text = person.vehicles[index].brand
        cell.model.text = person.vehicles[index].model
        if let image = person.vehicles[index].picture as Data? {
            cell.picture.image = UIImage.init(data: image)
        }
        else {
            cell.picture.image = UIImage.init(named: "машина2")
        }
        
        
        var count = 0
        for crash in person.vehicles[index].crashes{
            if crash.actual{
                count+=1
            }
        }
        
        if count==0 {
            cell.errorLabel.text="OK"
            cell.errorLabel.textColor=UIColor.green
        }
        else{
            cell.errorLabel.text="\(count) ошибки"
            cell.errorLabel.textColor=UIColor.red
        }
        
        if person.vehicles[index].isAuction {
            cell.marketLabel.text="Открыт"
            cell.marketLabel.textColor=UIColor.green
        }
        else{
            cell.marketLabel.text="Закрыт"
            cell.marketLabel.textColor=UIColor.red
        }
        
        //cell.vehicle = person.vehicles[index]
        return cell
    }
    
    var sendingVehicle:Vehicle?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        //person=DataBaseHelper.getPerson()
        var vehicle = person.vehicles[index]
        //vehicle = DataBaseHelper.getVehicle(id:person.vehicles[index].id)!
        //sendingVehicle=vehicle
        //APIHelper.getListOfActualCrashesRequest(vehicle: vehicle)
        self.performSegue(withIdentifier: "fromListOfVehicleToListOfCrashesSegue", sender: vehicle)
    }
 
//    func getVehiclesCallback(_ notification: NSNotification){
//        let person = DataBaseHelper.getPerson()
//        let data = notification.userInfo as! [String : JSON]
//        let vehicles = data["data"]!.arrayValue
//        for vehicle in vehicles {
//            DataBaseHelper.setVehicle(person: person, json: vehicle)
//        }
//        self.listOfVehiclesTable.reloadData()
//    }
    
    func getListsOfVehiclesAndCrashesCallback(_ notification: NSNotification){
        let person = DataBaseHelper.getPerson()
        let data = notification.userInfo as! [String : JSON]
        let jsonVehicles = data["data"]!.arrayValue
        var vehicleIDs = [Int]()
        for jsonVehicle in jsonVehicles {
            let id = jsonVehicle["id"].intValue
            vehicleIDs.append(id)
        }
        
        DataBaseHelper.deleteVehicles(vehicleIds: vehicleIDs)
        for jsonVehicle in jsonVehicles {
            let vehicle = DataBaseHelper.setVehicle(person: person, json: jsonVehicle)
            
            let jsonCrashes = jsonVehicle["crashes"].arrayValue
            for jsonCrash in jsonCrashes {
                _ = DataBaseHelper.setCrash(vehicle:vehicle, json:jsonCrash)
            }
        }
        listOfVehiclesTable.reloadData()
    }
    
 
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromListOfVehicleToListOfCrashesSegue"{
            let barViewController = segue.destination as! VehicleTabBarController
            //_ = sender as? VehicleCell
            barViewController.vehicle = sender as! Vehicle
            //print("sending vehicle id \(String(describing: sendingVehicle?.id))")
            let nav = barViewController.viewControllers![0] as! UINavigationController
            let destinationViewController = nav.viewControllers[0] as! ListOfCrashesViewController
            destinationViewController.vehicle = sender as! Vehicle
            destinationViewController.nowTypeCrash = .actual
        }

    }
    
    func refresh() {

        APIHelper.getListsOfVehiclesAndCrashesRequest()
        print("----------refresh----------")
        refreshControl.endRefreshing()
    }
    

}

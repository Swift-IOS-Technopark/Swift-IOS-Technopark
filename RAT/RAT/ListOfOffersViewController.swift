//
//  ListOfOffersViewController.swift
//  RAT
//
//  Created by Алексаndr on 20.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListOfOffersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var listOfOffersTable: UITableView!
    var person = Person()
    var vehicle:Vehicle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfOffersTable.dataSource = self
        listOfOffersTable.delegate = self
        listOfOffersTable.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(getListsOfOffersAndServicesCallback(_:)), name: .getListsOfOffersAndServicesCallback, object: nil)
        person = DataBaseHelper.getPerson()
        //print("recieved veh id \(vehicle?.id)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(vehicle!.offers.count)
        return vehicle!.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfOffersTable.dequeueReusableCell(withIdentifier: "OfferCell") as! OfferCell
        let index = indexPath.row
        if (vehicle?.offers[index].isAvalible)!{
            cell.isAvalible.text = "is Avalible"
        }
        else{
            cell.isAvalible.text = "not avaible"
        }
        cell.price.text = String(vehicle!.offers[index].price)// as String
        cell.service.text = vehicle?.offers[index].service?.name

        //cell.number.text = person.vehicles[index].number
        //ell.brand.text = person.vehicles[index].brand
        //ll.model.text = person.vehicles[index].model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        //let vehicle = person.vehicles[index]
        //APIHelper.getListOfActualCrashesRequest(vehicle: vehicle)
        self.performSegue(withIdentifier: "fromListOfOffersToOfferTabBarSegue", sender: vehicle)
    }
    

    
    func getListsOfOffersAndServicesCallback(_ notification: NSNotification){
        let person = DataBaseHelper.getPerson()
        
        let data = notification.userInfo as! [String : JSON]
        let jsonOffers = data["data"]!.arrayValue
        var offerIDs = [Int]()
        for jsonOffer in jsonOffers {
            let id = jsonOffer["id"].intValue
            offerIDs.append(id)
        }
        DataBaseHelper.deleteOffers(vehicle: vehicle!, offerIds: offerIDs)
        
        for jsonOffer in jsonOffers{
            let offer = DataBaseHelper.setOffer(vehicle: vehicle!, json: jsonOffer)
        }
        listOfOffersTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       /* //gavno
        let barViewController = segue.destination as! CrashTabBarController
        barViewController.vehicle = sender as? Vehicle
        let nav = barViewController.viewControllers![0] as! UINavigationController
        let destinationViewController = nav.viewControllers[0] as! ListOfCrashesViewController
        destinationViewController.vehicle = sender as! Vehicle
        destinationViewController.nowTypeCrash = .actual
        */
    }
}
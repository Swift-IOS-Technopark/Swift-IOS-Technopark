//
//  ListOfHighOffersViewController.swift
//  RAT
//
//  Created by Алексаndr on 22.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListOfHighOffersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var listOfOffersTable: UITableView!
    
    
    var person = Person()
    var vehicle:Vehicle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfOffersTable.dataSource = self
        listOfOffersTable.delegate = self
        // listOfOffersTable.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getListsOfHighLowOffersAndServicesCallback(_:)), name: .getListsOfHighLowOffersAndServicesCallback, object: nil)
        
        
        person = DataBaseHelper.getPerson()
        //print("recieved veh id \(vehicle?.id)")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(vehicle!.highOffers.count)
        return vehicle!.highOffers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfOffersTable.dequeueReusableCell(withIdentifier: "HighOfferCell") as! HighOfferCell
        let index = indexPath.row
        if (vehicle?.highOffers[index].isAvalible)!{
            cell.isAvalibleLabel.text = "is Avalible"
            cell.isAvalibleLabel.textColor = UIColor.green
        }
        else{
            cell.isAvalibleLabel.text = "not avaible"
            cell.isAvalibleLabel.textColor = UIColor.red
        }
        if (vehicle?.highOffers[index].isConfirmed)!{
            cell.isConfirmedLabel.text = "is Confirmed"
            cell.isConfirmedLabel.textColor = UIColor.green
        }
        else{
            cell.isConfirmedLabel.text = "not Confirmed"
            cell.isConfirmedLabel.textColor = UIColor.red
        }
        var price = 0
        for lowOffer in vehicle!.highOffers[index].lowOffers{
            price += lowOffer.price
        }
        
        cell.priceLabel.text = String(price)
        cell.dateLabel.text = vehicle?.highOffers[index].date
        cell.serviceName.text = vehicle?.highOffers[index].service?.name
        
        //serviceNameotal = 0
        var total = (vehicle?.highOffers[index].lowOffers.count)!
        var avalible = 0
        for low_offer in (vehicle?.highOffers[index].lowOffers)!{
            if low_offer.isAvalible{
                avalible+=1
            }
        }
        
        cell.errorLabel.text = "\(avalible)/\(total) errors can be fixed"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let sendOffer = vehicle!.highOffers[index]
        //APIHelper.getListOfActualCrashesRequest(vehicle: vehicle)
        self.performSegue(withIdentifier: "fromListOfOffersToService", sender: sendOffer)
    }
    
    
    
    func getListsOfHighLowOffersAndServicesCallback(_ notification: NSNotification){
        let person = DataBaseHelper.getPerson()
        let data = notification.userInfo as! [String : JSON]
        let jsonOffers = data["data"]!.arrayValue
        var offerIDs = [Int]()
        for jsonOffer in jsonOffers {
            let id = jsonOffer["id"].intValue
            offerIDs.append(id)
        }
        DataBaseHelper.deleteHighOffers(vehicle: vehicle!, offerIds: offerIDs)
        
        for jsonOffer in jsonOffers{
            _ = DataBaseHelper.setHighOffer(vehicle: vehicle!, json: jsonOffer)
        }
        listOfOffersTable.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromListOfOffersToService"{
            let serviceController = segue.destination as! ServiceViewController
            serviceController.offer = (sender as? HighOffer)!
            serviceController.service = ((sender as? HighOffer)?.service!)!}
        
        
    }
}

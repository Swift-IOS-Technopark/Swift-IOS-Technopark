//
//  ListOfLowOffersViewController.swift
//  RAT
//
//  Created by Алексаndr on 22.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//


import UIKit
import SwiftyJSON

class ListOfLowOffersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var listOfOffersTable: UITableView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var avalibleErrors: UILabel!
    @IBOutlet weak var chosenErrors: UILabel!
    @IBOutlet weak var totalPriseLabel: UILabel!
   
    
    var person = Person()
    var offer = HighOffer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listOfOffersTable.dataSource = self
        listOfOffersTable.delegate = self
        listOfOffersTable.tableFooterView = UIView()
        
        
        person = DataBaseHelper.getPerson()
        serviceLabel.text = offer.service?.name
        var text = ""
        text += (offer.vehicle?.brand)!+" "
        text += (offer.vehicle?.model)!+" "
        text += (offer.vehicle?.year)!
        vehicleLabel.text = text
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disapearing")
        APIHelper.updateHighOfferRequest(offer: offer)
    }
    
    func calcLabels(){
        var price = 0
        var total = offer.lowOffers.count
        var avalible = 0
        var chosen = 0
        for lowOffer in offer.lowOffers{
            if lowOffer.isAvalible{
                avalible += 1
            }
            if lowOffer.isChosen{
                chosen += 1
                price += lowOffer.price
            }
        }
        
        totalPriseLabel.text = String(price)
        avalibleErrors.text = "\(avalible)/\(total) can be fixed"
        chosenErrors.text = "\(chosen)/\(total) will be fixed"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offer.lowOffers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfOffersTable.dequeueReusableCell(withIdentifier: "LowOfferCell") as! LowOfferCell
        let index = indexPath.row
        
        cell.codeLabel.text = offer.lowOffers[index].crash?.code
        cell.priceLabel.text = String(offer.lowOffers[index].price)
        cell.crashLabel.text = offer.lowOffers[index].crash?.shortDescription
        cell.chosenSwitch.isOn = offer.lowOffers[index].isChosen
        cell.chosenSwitch.tag = index
        
        if offer.lowOffers[index].isAvalible{
            cell.naLabel.isHidden = true
            cell.chosenSwitch.isEnabled = true
            cell.chosenSwitch.isHidden = false
        }
        else{
            cell.naLabel.isHidden = false
            cell.chosenSwitch.isEnabled = false
            cell.chosenSwitch.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        let sendOffer = offer.lowOffers[index]
        if sendOffer.isAvalible{
            self.performSegue(withIdentifier: "toLowOfferView", sender: sendOffer)
        }
    }
    
    
    
    @IBAction func cellSwitchChanged(_ sender: Any) {
        print ((sender as! UISwitch).tag)
        print((sender as! UISwitch).isOn)
        //offer.lowOffers[(sender as! UISwitch).tag].isChosen = (sender as! UISwitch).isOn
        DataBaseHelper.setLowOffer(lowOffer:offer.lowOffers[(sender as! UISwitch).tag],isChosen: (sender as! UISwitch).isOn)
        calcLabels()
        listOfOffersTable.reloadData()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        offer = DataBaseHelper.setHighOffer(offer:offer, isConfirmed: true)
        APIHelper.updateHighOfferRequest(offer: offer)
        performSegue(withIdentifier: "fromConfirmToOfferList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromConfirmToOfferList"{
            
            //let serviceController = segue.destination as! ServiceViewController
            //serviceController.offer = (sender as? HighOffer)!
            //serviceController.service = ((sender as? HighOffer)?.service!)!}
            
            
            let navController = segue.destination as! UINavigationController
            
            let destinationViewController = navController.viewControllers[0] as! ListOfHighOffersViewController
            destinationViewController.vehicle = offer.vehicle
            APIHelper.getListsOfHighLowOffersAndServicesRequest(vehicle:offer.vehicle!)
            
        }
        if segue.identifier == "toLowOfferView"{
            
            let destinationController = segue.destination as! LowOfferViewController
            destinationController.offer = (sender as? LowOffer)!
            
        }
        
    }
}

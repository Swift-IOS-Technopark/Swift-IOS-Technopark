//
//  ConfirmViewController.swift
//  RAT
//
//  Created by Kirill on 4/13/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    var offer = Offer()
    
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        serviceLabel.text = offer.service?.name
        priceLabel.text = String(offer.price)
        messageLabel.text = offer.message
        
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "FromConfirmToOfferList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let offerController = navigationController.viewControllers[0] as! ListOfOffersViewController
        offerController.vehicle = offer.vehicle
        
    }
}

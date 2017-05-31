//
//  LowOfferViewController.swift
//  RAT
//
//  Created by Алексаndr on 28.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class LowOfferViewController: UIViewController {
    
    var offer = LowOffer()
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var crashLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.text = offer.crash?.code
        crashLabel.text = offer.crash?.shortDescription
        descriptionLabel.text = offer.crash?.fullDescription
        messageLabel.text = offer.message
        priceLabel.text = String(offer.price)
    }
    
    
    
}


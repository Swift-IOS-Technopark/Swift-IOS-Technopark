//
//  HighOfferCell.swift
//  RAT
//
//  Created by Алексаndr on 22.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class HighOfferCell: UITableViewCell {

    
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var isAvalibleLabel: UILabel!
    @IBOutlet weak var isConfirmedLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

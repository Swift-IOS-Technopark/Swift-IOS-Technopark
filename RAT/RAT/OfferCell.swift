//
//  OfferCell.swift
//  RAT
//
//  Created by Kirill on 4/12/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class OfferCell: UITableViewCell {

    @IBOutlet weak var service: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var isAvalible: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

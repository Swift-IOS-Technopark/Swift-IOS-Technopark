//
//  LowOfferCell.swift
//  RAT
//
//  Created by Алексаndr on 30.05.17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class LowOfferCell: UITableViewCell {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var crashLabel: UILabel!
    @IBOutlet weak var chosenSwitch: UISwitch!
    @IBOutlet weak var naLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

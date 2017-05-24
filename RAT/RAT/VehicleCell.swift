//
//  VehicleCell.swift
//  RAT
//
//  Created by Kirill on 3/30/17.
//  Copyright © 2017 RAT. All rights reserved.
//

import UIKit

class VehicleCell: UITableViewCell {
    
    
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var model: UILabel!
    //var vehicle:Vehicle?
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var marketLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

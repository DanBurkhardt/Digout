//
//  NearbyTableViewCell.swift
//  Digout
//
//  Created by Dan Burkhardt on 11/30/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit

class NearbyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var requestedByLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

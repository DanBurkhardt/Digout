//
//  HamburgerTopMenuCell.swift
//  Digout
//
//  Created by Daniel Burkhardt on 12/21/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

import UIKit

class HamburgerTopMenuCell: UITableViewCell {

    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

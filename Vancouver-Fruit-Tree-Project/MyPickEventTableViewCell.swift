//
//  MyPickEventTableViewCell.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Oliver Fujiki on 2018-07-16.
//  Edited by Chun Kei Li on 2018-07-31.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class MyPickEventTableViewCell: UITableViewCell {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var TeamLead: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}

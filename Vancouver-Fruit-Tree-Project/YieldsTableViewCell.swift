//
//  YieldsTableViewCell.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-07-31.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class YieldsTableViewCell: UITableViewCell {

    @IBOutlet weak var Fruit: UILabel!
    @IBOutlet weak var gradeAYield: UILabel!
    @IBOutlet weak var gradeBYield: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

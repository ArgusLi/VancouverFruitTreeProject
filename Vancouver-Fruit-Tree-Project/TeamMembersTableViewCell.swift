//
//  TeamMembersTableViewCell.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-07-31.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class TeamMembersTableViewCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Switch: UISwitch!
    var whichPick = PickEvents()
    let dbInterface = DatabaseInterface()
    var oddoreven = 0
    
    @IBAction func switchPressed(_ sender: Any) {
        if (oddoreven%2 == 0){
            dbInterface.markPresent(pickItem: whichPick!, userID: Name.text!)
        }
        else if(oddoreven%2 == 1){
            //mark absent
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

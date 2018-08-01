//
//  currentPickViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-07-31.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class currentPickViewController: UITabBarController {
    var currentPick = PickEvents()
    override func viewDidLoad() {
        super.viewDidLoad()

    
    let alltabs = self.viewControllers
        for tab in alltabs!{
            if tab is YieldViewController{
                let yeild = tab as! YieldViewController
              yeild.pickEvent = currentPick
            }
            if tab is FoodBankViewController{
                let drop = tab as! FoodBankViewController
                drop.pick = currentPick
            }
            if tab is TeamMembersTableViewController{
                let teamVc  = tab as! TeamMembersTableViewController
                teamVc.whichPick = currentPick
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

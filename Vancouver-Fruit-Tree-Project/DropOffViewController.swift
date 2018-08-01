//
//  DropOffViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-08-01.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class DropOffViewController: UIViewController {

    var whichPick = PickEvents()
    let dbInterface = DatabaseInterface()
    @IBOutlet weak var partner: UILabel!
    @IBOutlet weak var openingHours: UILabel!
    @IBOutlet weak var closingHours: UILabel!
    @IBOutlet weak var notes: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

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

//
//  YieldViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-07-31.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class YieldViewController: UIViewController {
    let dbInterface = DatabaseInterface()
    var pickEvent = PickEvents()
    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    @IBOutlet weak var typeOfFruit: UILabel!
    @IBOutlet weak var gradeAYield: UITextField!
    @IBOutlet weak var gradeBYield: UITextField!
    @IBOutlet weak var save: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pickEvent != nil{
            if pickEvent?._treeMap != nil{
                if pickEvent?._treeMap?.index(forKey: TreeProperties.type.rawValue) != nil {
                    typeOfFruit.text = "Type of a tree \(pickEvent!._treeMap![TreeProperties.type.rawValue]!)"
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePress(_ sender: Any) {
        if (self.gradeAYield.hasText == true && self.gradeBYield.hasText == true){
            pickEvent?._completed = "1"
            dbInterface.logYield(pickItem: pickEvent, dict: [pickEvent!._treeMap![TreeProperties.type.rawValue]!:[self.gradeAYield.text!, self.gradeBYield.text!]])
            
            alert.title = "Yield Saved Successfully"
            alert.message = "The Yield has been successfully saved"
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        
        }
        else{
            alert.title = "Error"
            alert.message = "There are no yields"
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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

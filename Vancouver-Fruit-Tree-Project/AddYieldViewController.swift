//
//  AddYieldViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-07-29.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class AddYieldViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerChoice:String = "Apple"
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var gradeAField: UITextField!
    @IBOutlet weak var gradeBField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //Adding picker information
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Connecting Picker to Picker choices:
        self.picker.delegate=self
        self.picker.dataSource=self
        
        
        //Picker choices:
        pickerData=["Apple", "Apricot", "Blackberry", "BoysenBerry", "Cantaloupe", "Cherry", "Grape", "Huckleberry", "Kiwi", "Melon", "Peach", "Pear", "Persimmon", "Plum", "Raspberry", "Strawberry", "Watermelon"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerChoice=pickerData[row]
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

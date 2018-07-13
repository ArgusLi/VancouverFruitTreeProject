//
//  AddPickEventViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-07-07.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit
class AddPickEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, setLocation {
    
    

    var event = PickEvents()
    var typeofTrees = [String]()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    func setUpFormatters(){
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "YYYY/MM/dd"
        timeFormatter.dateFormat = .none
        timeFormatter.timeStyle = .full
        timeFormatter.dateFormat = "hh:mm:ss"
    }
    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var addressTitle: UIButton!
    @IBAction func addressButton(_ sender: Any) {
        let searchAdressVC = storyboard?.instantiateViewController(withIdentifier: "SearchLocationTableViewController") as! SearchLocationTableViewController
        searchAdressVC.delegate = self
        navigationController?.pushViewController(searchAdressVC, animated: true)
    }
    @IBOutlet weak var dateandtimeSelector: UIDatePicker!
    @IBAction func dateChanged(sender: UIDatePicker){
        event?._eventDate = dateFormatter.string(from: dateandtimeSelector.date)
        event?._eventTime = timeFormatter.string(from: dateandtimeSelector.date)
        
    }
    @IBAction func saveButton(_ sender: Any) {
        if (event?._latitude == nil || event?._longitude == nil)
        {
            let alert = UIAlertController(title: "Location missing", message: "Please provide location of the pick", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        else{
            print(typeofTrees[typeTreeSelector.selectedRow(inComponent: 0)])
            //let database = DatabaseInterface()
            //TODO: database.createNewEvent(event)
            let alert = UIAlertController(title: "Event Saved Successfully", message: "The event has been successfully saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in self.navigationController?.popViewController(animated: true) }))
            self.present(alert, animated: true)
            
        }
    }
    @IBOutlet weak var numberofTrees: UILabel!
    
    @IBOutlet weak var treeStepper: UIStepper!
    
    @IBOutlet weak var volunteerStepper: UIStepper!
    
    @IBAction func treeChanged(_ sender: Any) {
        numberofTrees.text = "Trees: \(Int(treeStepper.value))"
    }
    @IBOutlet weak var numberofVolunteers: UILabel!
    
    @IBAction func volunteersChanged(_ sender: Any) {
        numberofVolunteers.text = "Volunteers: \(Int(volunteerStepper.value))"
        print("Volunteers Changed")
    }
    @IBOutlet weak var typeTreeSelector: UIPickerView!
    var resultSearchController:UISearchController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        save.layer.cornerRadius = 8
        dateandtimeSelector.minimumDate = Date()
        setUpFormatters()
        typeTreeSelector.delegate = self
        typeTreeSelector.dataSource = self
        event?._eventDate = dateFormatter.string(from: dateandtimeSelector.date)
        event?._eventTime = timeFormatter.string(from: dateandtimeSelector.date)
        typeofTrees = ["none","Apple", "Orange", "Plum"]
        

        // Do any additional setup after loading the view.
    }
    
    func getLocation(location: MKMapItem, address: String?) {
        if (location.placemark.location != nil){
        event?._latitude = NSNumber(value:(location.placemark.location?.coordinate.latitude)!)
        event?._longitude = NSNumber(value:(location.placemark.location?.coordinate.longitude)!)
           addressTitle.setTitle(address, for: .normal)
            addressTitle.setTitleColor(.black, for: .normal)
        
        }
        else{
            let alert = UIAlertController(title: "Error", message: "There has been some problem with getting location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeofTrees.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return typeofTrees[row]
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

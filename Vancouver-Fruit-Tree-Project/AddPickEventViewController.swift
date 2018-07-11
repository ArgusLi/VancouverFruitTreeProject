//
//  AddPickEventViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-07-07.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit
class AddPickEventViewController: UIViewController, setLocation {

    var event = PickEvents()
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
        else if (event?._eventTime == nil || event?._eventDate == nil)
        {
            let alert = UIAlertController(title: "Time not specified", message: "Please provide the date and time of the pick", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else{
            let database = DatabaseInterface()
            //TODO: database.createNewEvent(event)
        }
    }
    @IBOutlet weak var numberofTrees: UILabel!
    @IBAction func treeIncrementer(_ sender: Any) {
    }
    @IBOutlet weak var numberofVolunteers: UILabel!
    @IBAction func volunteerIncrementer(_ sender: Any) {
    }
    @IBOutlet weak var typeTreeSelector: UIPickerView!
    var resultSearchController:UISearchController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        dateandtimeSelector.minimumDate = Date()
        setUpFormatters()
        
        event?._eventDate = dateFormatter.string(from: dateandtimeSelector.date)
        event?._eventTime = timeFormatter.string(from: dateandtimeSelector.date)
        
        

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

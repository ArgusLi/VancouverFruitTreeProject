//
//  AddDropOffLocationViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-07-29.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit
class AddDropOffLocationViewController: UIViewController , setLocation{
    
    func getLocation(location: MKMapItem, address: String?) {
        if (address != nil){
            
            addressTitle.setTitle(address, for: .normal)
            addressTitle.setTitleColor(.black, for: .normal)
            partner[dropOffFields.location.rawValue] = address
            
        }
    }
    var partner = communityPartner()
    var delegate: getDropOff?
    @IBOutlet weak var addressTitle: UIButton!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var openingTime: UIDatePicker!
    @IBOutlet weak var closingTime: UIDatePicker!
    @IBOutlet weak var notes: UITextView!
    
    @IBAction func complete(_ sender: Any) {
        
        if(partner.index(forKey: dropOffFields.location.rawValue) == nil ){
            print("Missing location")
            return
        }
        if(closingTime.date < openingTime.date){
            print("cannot set closing time before the openning time")
            return
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        print(formatter.string(from: closingTime.date))
        partner[dropOffFields.opentime.rawValue] = "\(formatter.string(from: openingTime.date)) \(formatter.string(from: closingTime.date))"
        if notes.text != nil{
            partner[dropOffFields.notes.rawValue] = notes.text!
        }
        //pass data back to the add pick event view controller
        delegate?.setDropOff(partner: partner)
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBAction func addressButton(_ sender: Any) {
        
        let searchAdressVC = storyboard?.instantiateViewController(withIdentifier: "SearchLocationTableViewController") as! SearchLocationTableViewController
        searchAdressVC.delegate = self
        
        self.navigationController?.pushViewController(searchAdressVC, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let controllers = navigationController?.viewControllers
        for controller in controllers!{
            if controller is AddDropOffLocationViewController
            {
                controller.navigationItem.rightBarButtonItem = okButton
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
protocol getDropOff {
    
    func setDropOff(partner: communityPartner)
}

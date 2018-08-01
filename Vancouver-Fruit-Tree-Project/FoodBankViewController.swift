//
//  FoodBankViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Jeff Lee on 2018-07-18.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit


class FoodBankViewController: UIViewController {
    var pick: PickEvents?

    
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var FBMapView: MKMapView!
    @IBOutlet weak var theAddress: UILabel!
    @IBOutlet weak var institutionName: UILabel!
    
    @IBOutlet weak var hours: UILabel!
    //opens map app when clicked
    @IBAction func directionClicked(_ sender: UIButton) {
        //remove all whitespaces in the string
        if (theAddress.text != "-" || pick?._dropOffLocation?.index(forKey: dropOffFields.location.rawValue) != nil){
            let destination = theAddress.text?.replacingOccurrences(of: " ", with: "")
            
            //opens Apple map app and navigate to the address
            let urlDirection = URL(string: "http://maps.apple.com/?daddr="+destination!)
            UIApplication.shared.open(urlDirection!, options: [:], completionHandler: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pick == nil{
            print("Pick is nil")
        }
        else if(pick?._dropOffLocation == nil){
            print("No food bank information")
        }
        else {
            if(pick?._dropOffLocation?.index(forKey: dropOffFields.name.rawValue) != nil){
                institutionName.text = pick?._dropOffLocation![dropOffFields.name.rawValue]
            }
            if(pick?._dropOffLocation?.index(forKey: dropOffFields.location.rawValue) != nil){
                theAddress.text = pick?._dropOffLocation![dropOffFields.location.rawValue]
            }
            if(pick?._dropOffLocation?.index(forKey: dropOffFields.opentime.rawValue) != nil){
                hours.text = pick?._dropOffLocation![dropOffFields.opentime.rawValue]
            }
            if(pick?._dropOffLocation?.index(forKey: dropOffFields.notes.rawValue) != nil){
                notes.text = pick?._dropOffLocation![dropOffFields.notes.rawValue]
            }
        }
        let location = theAddress.text
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location!) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)
                
                if var region = self?.FBMapView.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta /= 500.0
                    region.span.latitudeDelta /= 500.0
                    self?.FBMapView.setRegion(region, animated: true)
                    self?.FBMapView.addAnnotation(mark)
                }
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

//
//  PickDetailsViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-06-30.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit

class PickDetailsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var event: PickEvents? = nil
    var getCoordinates: CLLocationCoordinate2D?
    var locationManager: CLLocationManager = CLLocationManager()
    var buttonTitle: String?
    var buttonColour: UIColor?
    var gettypeofTrees: String?
    @IBOutlet weak var date: UIButton!
    
    
    @IBOutlet weak var time: UIButton!
    
    @IBOutlet weak var teamlead: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var typeOfTrees: UIButton!
    @IBOutlet weak var signupbotton: UIButton!
   
    @IBAction func donationCenter(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FoodBankViewController") as! FoodBankViewController
        vc.pick = event
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func signup(_ sender: Any) {
        let DBINT = DatabaseInterface()
        let userName = DBINT.getUsername()
        if signupbotton.title(for: .normal) == ButtonStates.signup.rawValue {
            
            
            if (userName != nil && event != nil){
                DBINT.signUpForPickEvent(pickItem: event!, userId: userName!)
                let alert = UIAlertController(title: "Sign-up succesful", message: "Thank you for signing up", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (handler) in
                    self.navigationController?.popViewController(animated: true) }))
                self.present(alert, animated: true)
                
            }
            else{
                print("There has been some problem, userName or event is nil")
            }
        }
        if signupbotton.title(for: .normal) == ButtonStates.cancel.rawValue{
            if (userName != nil && event != nil){
                DBINT.removeSignUpForPickEvent(pickItem: event!, userId: userName!)
                let alert = UIAlertController(title: "Cancelation successful", message: "You cancelled your partipication in the event", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (handler) in
                    self.navigationController?.popViewController(animated: true) }))
                self.present(alert, animated: true)
              
            }
            else{
                print("There has been some problem, userName or event is nil")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let DBINT = DatabaseInterface()
        let volunteers = DBINT.getVolunteers(pickItem: event!)
        let userName = DBINT.getUsername()
        if let users = DBINT.queryUserInfo(userId: userName!){
            //Checks if the current user has signed up for this event already, and set the button to cancel is yes
            if (volunteers.index(of: users) != nil || event?._teamLead == userName){
                buttonTitle = ButtonStates.cancel.rawValue
                buttonColour = UIColor.red
            }
            else{
                buttonTitle = nil
                buttonColour = nil
            }
        }
        
            
        
        
        
        signupbotton.layer.cornerRadius = 8
        if (event!._eventDate != nil && event!._eventTime != nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let dt = dateFormatter.date(from: (event!._eventDate!))
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
            
            let tm = timeFormatter.date(from: "\(event!._eventDate!) \(event!._eventTime!)")
            timeFormatter.timeStyle = .short
            timeFormatter.dateStyle = .none
            timeFormatter.locale = Locale(identifier: "en_US")
            
            
            
            
            
            
            // US English Locale (en_US)
            dateFormatter.locale = Locale(identifier: "en_US")
            date.setTitle("Date:  \(dateFormatter.string(from: dt!))", for: .normal)
            
            time.setTitle("Time: \(timeFormatter.string(from: tm!))", for: .normal)
            
            
            if event!._treeMap != nil {
                typeOfTrees.setTitle("Type of trees: \(event!._treeMap![TreeProperties.type.rawValue]!)", for: .normal)
            }
            
            if((event!._latitude!.floatValue > -90  && event!._latitude!.floatValue < 90) && ( event!._longitude!.floatValue > -180 && event!._longitude!.floatValue  < 180 ))
            {
                
                
                getCoordinates = CLLocationCoordinate2D(latitude: Double(event!._latitude!.floatValue) as CLLocationDegrees, longitude: Double(event!._longitude!.floatValue) as CLLocationDegrees)
            }
            if(event?._teamLead != nil){
                teamlead.setTitle("Team lead: \(event!._teamLead!)", for: .normal)
            }
        }
        if (buttonTitle != nil && buttonColour != nil) {
            signupbotton.setTitle(buttonTitle!, for: .normal)
            signupbotton.backgroundColor = buttonColour!
        }
        self.tabBarController?.tabBar.isHidden = true
        
        if getCoordinates != nil{
            
        
        mapView.setCenter( getCoordinates!, animated: true)
        
        let mapspan = MKCoordinateSpanMake(0.1, 0.1)
        let mapregion = MKCoordinateRegionMake(getCoordinates!, mapspan)
        
        self.mapView.setRegion(mapregion, animated: true)
        //let annontation = MapAnnotation(coor: getCoordinates, title: "Test Title")
        //mapView.addAnnotation(annontation)
        addRadius(location: getCoordinates!)
        
        }
        

        
        
        

        // Do any additional setup after loading the view.
    }
    func addRadius(location: CLLocationCoordinate2D){
        mapView.delegate = self
        let circle = MKCircle(center:location , radius: 1000 )
        self.mapView.add(circle)
    }
    

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer! {
        if getCoordinates != nil {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.green
            circle.fillColor = UIColor.green
            circle.lineWidth = 1
            circle.alpha = 0.5
            return circle
        } else {
            return nil
            }}
        else {return nil}
        
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




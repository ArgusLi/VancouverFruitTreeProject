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
    @IBAction func signup(_ sender: Any) {
        if signupbotton.title(for: .normal) == "Sign-up" {
            let DBINT = DatabaseInterface()
            let userName = DBINT.getUsername()
            if (userName != nil && event != nil){
                DBINT.signUpForPickEvent(pickItem: event!, userId: userName!)
                let alert = UIAlertController(title: "Sign-up succesful", message: "Thank you for signing up", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else{
                print("There has been some problem, userName or event is nil")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupbotton.layer.cornerRadius = 8
        if (event!._eventDate != nil && event!._eventTime != nil) {
            date.setTitle("Date:  \(event!._eventDate!)", for: .normal)
            
            time.setTitle("Time: \(event!._eventTime!)", for: .normal)
            if event!._assignedTeamID != nil {
                teamlead.setTitle( "Team Lead: \(event!._assignedTeamID!)", for: .normal)
            }
            
            if event!._treeMap != nil {
                typeOfTrees.setTitle("Type of trees: \(event!._treeMap!["type-of-trees"]!)", for: .normal)
            }
            
            if((event!._latitude!.floatValue > -90  && event!._latitude!.floatValue < 90) && ( event!._longitude!.floatValue > -180 && event!._longitude!.floatValue  < 180 ))
            {
                
                
                getCoordinates = CLLocationCoordinate2D(latitude: Double(event!._latitude!.floatValue) as CLLocationDegrees, longitude: Double(event!._longitude!.floatValue) as CLLocationDegrees)
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




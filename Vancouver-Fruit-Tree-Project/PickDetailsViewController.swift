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
    var getdate = String()
    var gettime =  String()
    var getleader = String()
    var getCoordinates: CLLocationCoordinate2D?
    var locationManager: CLLocationManager = CLLocationManager()
    
    
    @IBOutlet weak var date: UIButton!
    
    
    @IBOutlet weak var time: UIButton!
    
    @IBOutlet weak var teamlead: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var signupbotton: UIButton!
    @IBAction func signup(_ sender: Any) {
        let alert = UIAlertController(title: "This functionality is unavailable", message: "We are currently working on this, check back later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.layer.cornerRadius = 8
        time.layer.cornerRadius = 8
        teamlead.layer.cornerRadius = 8
        signupbotton.layer.cornerRadius = 8
        self.tabBarController?.tabBar.isHidden = true
        date.setTitle(getdate, for: .normal)
        time.setTitle(gettime, for: .normal)
        teamlead.setTitle( "Team Lead: \(getleader)", for: .normal)
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




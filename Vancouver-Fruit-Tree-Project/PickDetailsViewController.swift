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
    var getCoordinates = CLLocationCoordinate2D()
    var locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var teamlead: UILabel!
    @IBOutlet weak var mapView: MKMapView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        date.text=getdate
        time.text = gettime
        teamlead.text = "Team Lead: \(getleader)"
        mapView.setCenter( getCoordinates, animated: true)
        
        let mapspan = MKCoordinateSpanMake(0.1, 0.1)
        let mapregion = MKCoordinateRegionMake(getCoordinates, mapspan)
        
        self.mapView.setRegion(mapregion, animated: true)
        
        

        
        
        

        // Do any additional setup after loading the view.
    }
    func addRadius(location: CLLocationCoordinate2D){
        self.mapView.delegate = self
        var circle = MKCircle(center: getCoordinates , radius: 100 )
        self.mapView.add(circle)
    }
    

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.green
            circle.fillColor = UIColor.green
            circle.lineWidth = 1
            return circle
        } else {
            return nil
        }
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




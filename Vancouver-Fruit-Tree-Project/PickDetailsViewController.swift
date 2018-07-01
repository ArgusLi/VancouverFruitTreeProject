//
//  PickDetailsViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-06-30.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit
class PickDetailsViewController: UIViewController {
    var getdate = String()
    var gettime =  String()
    var getleader = String()
    var getCoordinates = CLLocationCoordinate2D()
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var teamlead: UILabel!
    @IBOutlet weak var mapView: MKMapView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        date.text=getdate
        time.text = gettime
        teamlead.text = "Team Lead: \(getleader)"
        mapView.setCenter( getCoordinates, animated: true)
        let circle = MKCircle(center: getCoordinates , radius: 100 )
        let mapspan = MKCoordinateSpanMake(0.1, 0.1)
        let mapregion = MKCoordinateRegionMake(getCoordinates, mapspan)
        
        self.mapView.setRegion(mapregion, animated: true)
        self.mapView.add(circle)
        

        
        
        

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

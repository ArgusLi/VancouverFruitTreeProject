//
//  PickEventMapViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-07-01.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit
class PickEventMapViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    let vancouverlocation = CLLocationCoordinate2DMake(  49.246292, -123.116226)
    let mapspan = MKCoordinateSpanMake(0.8, 0.8)
    var Events = [Any]()
    func reset(){
       let location = MKCoordinateRegion(center: vancouverlocation, span:mapspan)
        mapView.setRegion(location, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        

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

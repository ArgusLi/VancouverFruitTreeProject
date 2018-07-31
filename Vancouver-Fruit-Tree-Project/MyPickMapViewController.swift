//
//  MyPickMapViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Oliver Fujiki on 2018-07-16.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit

class MyPickMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let vancouverlocation = CLLocationCoordinate2DMake(  49.246292, -123.116226)
    let mapspan = MKCoordinateSpanMake(0.5, 0.5)
    
    func reset(){
        let location = MKCoordinateRegion(center: vancouverlocation, span:mapspan)
        mapView.setRegion(location, animated: true)
        
    }
    
    var myPicks=[PickEvents]()
    
    
    func addPins(Events:[PickEvents])
    {
        for event in Events{
        mapView.delegate = self
        
        if((event._latitude!.floatValue > -90  && event._latitude!.floatValue < 90) && ( event._longitude!.floatValue > -180 && event._longitude!.floatValue  < 180 ))
        {
            let location = CLLocationCoordinate2DMake(Double(event._latitude!.floatValue) as CLLocationDegrees, Double(event._longitude!.floatValue) as CLLocationDegrees)
            let annontation = MapAnnotation(coor: location, title: event._address)
            mapView.addAnnotation(annontation)
            
        }
        
        }
       
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle{
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.green
            circleRenderer.strokeColor = UIColor.green
            circleRenderer.lineWidth = 1
            circleRenderer.alpha = 0.5
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.showsUserLocation = true
        addPins(Events: myPicks)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        let mpTVC = storyboard?.instantiateViewController(withIdentifier: "MyPicksTableViewController") as! MyPicksTableViewController
        myPicks = mpTVC.loadMyPicks()!
        addPins(Events: myPicks)
        locationManager.requestLocation()
    }
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            
        }
        if (status == .denied || status == .restricted)
        {
            reset()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
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

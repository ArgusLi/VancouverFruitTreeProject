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
    
    let vancouverlocation = CLLocationCoordinate2DMake(  49.246292, -123.116226)
    let mapspan = MKCoordinateSpanMake(0.5, 0.5)
    
    func reset(){
        let location = MKCoordinateRegion(center: vancouverlocation, span:mapspan)
        mapView.setRegion(location, animated: true)
        
    }
    
    var myPicks=[PickEvents]()
    private func loadMyPicks()
    {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let interface = DatabaseInterface()
        let maxDate = String(year)+"/" + String(month)+"/"+String(day + 4)
        myPicks =  interface.scanPickEvents(itemLimit: 3, maxDate: maxDate)
        
    }
    
    func addPins(Events:[PickEvents])
    {
        for event in Events{
        mapView.delegate = self
        
        if((event._latitude!.floatValue > -90  && event._latitude!.floatValue < 90) && ( event._longitude!.floatValue > -180 && event._longitude!.floatValue  < 180 ))
        {
            let location = CLLocationCoordinate2DMake(Double(event._latitude!.floatValue) as CLLocationDegrees, Double(event._longitude!.floatValue) as CLLocationDegrees)
            let circle = MKCircle(center: location, radius: 1000)
            mapView.add(circle)
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
        loadMyPicks()
        addPins(Events: myPicks)
        
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

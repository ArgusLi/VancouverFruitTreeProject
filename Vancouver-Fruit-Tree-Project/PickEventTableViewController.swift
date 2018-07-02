//
//  PickEventTableViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-06-30.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit
class PickEventTableViewController: UITableViewController {
    
    // TODO: Insert an array declaration here
    //TODO: placeholder for a pick event class
    struct PickEvent {
        var date :NSNumber?
        var time :NSNumber?
        var teamlead :String?
        var longtitute : CLLocationDegrees?
        var latitude : CLLocationDegrees?
    }
    var pickevents = [PickEvent]()
   private func loadavailablepicks()
   {
    for _ in 1...10{
        let pickevent = PickEvent(date:  123, time: 12, teamlead: "Test lead", longtitute: -122.9180  as CLLocationDegrees, latitude: 49.2768 as CLLocationDegrees)
        pickevents.append(pickevent)
    }
    
    
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadavailablepicks()
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "PickEventMapViewController") as! PickEventMapViewController
        mapVC.Events = pickevents
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pickevents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellidentifier = "PickEventTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as? PickEventTableViewCell else {
            fatalError("The dequeued cell is not an instance of \(cellidentifier)")
            
        }
        let pick = pickevents[indexPath.row]
        cell.Time.text="\(pick.time!)"
        cell.Date.text = "\(pick.date!)"
        cell.TeamLead.text = "Team Lead: \(pick.teamlead!)"

        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = pickevents[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "PickDetailsViewController") as! PickDetailsViewController
        if ((event.date != nil && event.teamlead != nil) && event.teamlead != nil){
        detailVC.getdate = "\(event.date!)"
        detailVC.gettime = "\(event.time!)"
        detailVC.getleader = "\(event.teamlead!)"
            detailVC.getCoordinates = CLLocationCoordinate2D(latitude: event.latitude!, longitude: event.longtitute!)
            
        self.navigationController?.pushViewController(detailVC, animated: true)}
        else
        {
            print("At least on of the attributes is nil")
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

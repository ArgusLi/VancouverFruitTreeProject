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
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var picks=[PickEvents]()
   private func loadavailablepicks()
   {
    let date = Date()
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let interface = DatabaseInterface()
    let maxDate = String(year)+"/" + String(month + 6)+"/"+String(day)
    picks =  interface.scanPickEvents(itemLimit: 100, maxDate: maxDate)
    
    }
   
    override func viewDidLoad() {
        
        
        let controllers = navigationController?.viewControllers
        for controller in controllers!{
            if controller is UITabBarController
            {
                controller.navigationItem.rightBarButtonItem = addButton
            }
        }
        
        super.viewDidLoad()
        
        
        
        loadavailablepicks()
        
        super.view.isUserInteractionEnabled = true

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
        return picks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellidentifier = "PickEventTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as? PickEventTableViewCell else {
            fatalError("The dequeued cell is not an instance of \(cellidentifier)")
            
        }
        let pick = picks[indexPath.row]
        cell.Time.text="Time: " + pick._eventTime!
        cell.Date.text = "Date: " + pick._eventDate!
        cell.TeamLead.text = "Team lead: none"
        if (indexPath.row % 2 == 0){
            cell.sideImage.image = UIImage(named: "Green alert")}
        else if(indexPath.row % 5 == 0){
            cell.sideImage.image = UIImage(named: "Red Alert")
        }
        else{
            cell.sideImage.image = UIImage(named: "Amber Alert")
        }

        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = picks[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "PickDetailsViewController") as! PickDetailsViewController
        if ((event._eventDate != nil && event._eventTime != nil) && event._assignedTeamID != nil){
            detailVC.getdate = "Date: " + event._eventDate!
            detailVC.gettime = "Time: " + event._eventTime!
        detailVC.getleader = "none"
            if((event._latitude!.floatValue > -90  && event._latitude!.floatValue < 90) && ( event._longitude!.floatValue > -180 && event._longitude!.floatValue  < 180 ))
            {
                
            
            detailVC.getCoordinates = CLLocationCoordinate2D(latitude: Double(event._latitude!.floatValue) as CLLocationDegrees, longitude: Double(event._longitude!.floatValue) as CLLocationDegrees)
            }
            else {
                detailVC.getCoordinates = nil
            }
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

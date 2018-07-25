//
//  MyPicksTableViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Oliver Fujiki on 2018-07-16.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit

class MyPicksTableViewController: UITableViewController {
    
    
    //Array declaration
    var myPicks=[PickEvents]()
    
    //
    private func loadMyPicks()
    {
        
        //Temprorary func until we get database to load myPicks
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let interface = DatabaseInterface()
        let maxDate = String(year)+"/" + String(month)+"/"+String(day + 4)
        myPicks = interface.scanPickEvents(itemLimit: 3, maxDate: maxDate)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadMyPicks()
        
        //tableView.register(MyPickEventTableViewCell.self, forCellReuseIdentifier: "MyPickEventTableViewCell")

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
        
        //Counting number of rows
        return myPicks.count
    }
    
    

    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MyPickEventTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyPickEventTableViewCell else {
            fatalError("Dequeued cell is not an instance of \(cellIdentifier)")
        }
        
        let myPick = myPicks[indexPath.row]
        
            cell.Time.text = "Time: " + myPick._eventTime!
            cell.Date.text = "Date: " + myPick._eventDate!
            cell.TeamLead.text = "NA"
        
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = myPicks[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "PickDetailsViewController") as! PickDetailsViewController
        
        detailVC.buttonColour = UIColor.red
        detailVC.buttonTitle = "Cancel"
        if (event._eventDate != nil && event._eventTime != nil){
            detailVC.event = event
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
            print("At least one of the attributes is nil")
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

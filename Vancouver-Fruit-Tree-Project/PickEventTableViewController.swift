//
//  PickEventTableViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-06-30.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit
class PickEventTableViewController: UITableViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    // TODO: Insert an array declaration here
    //TODO: placeholder for a pick event class
    let gr =  DispatchGroup()
    @IBOutlet weak var addButton: UIBarButtonItem!
    var picks=[PickEvents]()
    private var myLocation: CLLocation?
   private func loadavailablepicks()
   {
    //loads available picks 6 months from today, and puts them into picks array
    let date = Date()
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let interface = DatabaseInterface()
    let maxDate = String(year)+"/" + String(month + 6)+"/"+String(day)
    picks =  interface.scanPickEvents(itemLimit: 100, maxDate: maxDate)
    picks = picks.sorted(by: {$0.getDate()! < $1.getDate()!})
    }
    private func setTheDistance(location: CLLocation){
        for pick in picks{
            if (pick._latitude != nil && pick._longitude != nil){
            let destination = CLLocation(latitude: Double(truncating: pick._latitude!), longitude: Double(truncating: pick._longitude!))
            let distance = location.distance(from:destination)
                pick._distanceFrom = NSNumber(value: distance)
            }
            
        }
    }
   
    override func viewDidLoad() {
        let DBIT = DatabaseInterface()
        let user = DBIT.queryUserInfo(userId: DBIT.getUsername()!)
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.tintColor = UIColor.green
        self.refreshControl!.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        self.tableView.insertSubview(self.refreshControl!, at: 0)
        if(user?._role == Roles.admin.rawValue){
        let controllers = navigationController?.viewControllers
        for controller in controllers!{
            if controller is UITabBarController
            {
                controller.navigationItem.rightBarButtonItem = addButton
            }
        }
        }
        super.viewDidLoad()
        
        loadavailablepicks()
        //delete all the events without team lead for volunteers
        if (user?._role == Roles.volunteer.rawValue){
            var items = [PickEvents]()
            for pick in picks{
                if pick._teamLead == nil{
                    items.append(pick)
                }
            }
            for i in items{
                picks.remove(at: picks.index(of: i)!)
            }
        }
        //remove all the events that have leaders
        if (user?._role == Roles.lead.rawValue){
            var items = [PickEvents]()
            for pick in picks{
                if pick._teamLead != nil{
                    items.append(pick)
                }
            }
            for i in items{
                picks.remove(at: picks.index(of: i)!)
            }
        }
        super.view.isUserInteractionEnabled = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        gr.enter()
        DispatchQueue.main.async{
           self.locationManager.requestLocation()
        }
        gr.notify(queue: .main){
            if self.myLocation != nil{
             self.setTheDistance(location: self.myLocation!)
                self.tableView.reloadData()
            }
            else{
                print("Location is nil")
            }
        }
        
        

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
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        loadavailablepicks()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date = dateFormatter.date(from: pick._eventDate!)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
        
        let time = timeFormatter.date(from: "\(pick._eventDate!) \(pick._eventTime!)")
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none
        timeFormatter.locale = Locale(identifier: "en_US")
        
        cell.Time.text="Time: " + timeFormatter.string(from: time!)
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        
        cell.Date.text = "Date: " + dateFormatter.string(from: date!)
        
        if pick._distanceFrom != nil{
            if (Int(truncating: pick._distanceFrom!) > 500){
                cell.DistanceFrom.text = "\(Int(truncating: pick._distanceFrom!)/1000) km away"
            }
            else{
                cell.DistanceFrom.text = "\(pick._distanceFrom!.intValue) m away"}
        }
        else{
            cell.DistanceFrom.text = ""
        }
        if let lead = pick._teamLead{
            cell.TeamLead.text = "Team lead: \(lead)"
        }
        else{
            cell.TeamLead.text = "Team lead: none"}
        if (pick._teamLead == nil){
            cell.sideImage.image = UIImage(named: "Red Alert")}
        else if(!pick.isFull()){
            cell.sideImage.image = UIImage(named: "Amber Alert")
        }
        else{
            cell.sideImage.image = UIImage(named: "Green alert")
        }

        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = picks[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "PickDetailsViewController") as! PickDetailsViewController
        detailVC.event = event
      
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let DBIT = DatabaseInterface()
        let user = DBIT.queryUserInfo(userId: DBIT.getUsername()!)
        return user?._role == Roles.admin.rawValue
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        
            
        
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let pick = picks[indexPath.row]
            
            picks.remove(at: indexPath.row)
            
            let DBINT = DatabaseInterface()
            let result = DBINT.deletePickEvent(itemToDelete: pick)
            if result == 1{
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else{
                print("The event was not deleted")
            }
            
          /*
            
            loadavailablepicks()
            self.viewDidLoad()
            */
        }
            
        
        
    }
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        if (status == .denied || status == .restricted)
        {
            print("Location services is not enabled")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        if let location = locations.first {
            
            myLocation = location
            gr.leave()
            
        }
        else{
            gr.leave()}
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
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

//
//  SearchLocationTableViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-07-08.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import MapKit
protocol setLocation {
    
    func getLocation(location: MKMapItem, address: String?)
}
class SearchLocationTableViewController: UITableViewController {
    var Locations = [MKMapItem]()

    var delegate:setLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let resultSearchController = UISearchController(searchResultsController: nil)
        
        
        resultSearchController.searchResultsUpdater = self
        navigationItem.searchController = resultSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
       navigationItem.searchController?.isActive = true
   
    
        
        navigationItem.searchController?.searchBar.becomeFirstResponder()
        let searchBar = resultSearchController.searchBar
        
        searchBar.placeholder = "Enter Adress"
        
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
      
        definesPresentationContext = true

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
        return Locations.count
    }
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let location =  Locations[indexPath.row]
        let adressstring = parseAddress(selectedItem: location.placemark)
        delegate?.getLocation(location: location, address: adressstring)
        navigationController?.popViewController(animated: true)
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)

        let location = Locations[indexPath.row].placemark
         cell.textLabel?.text = parseAddress(selectedItem: location)
        cell.detailTextLabel?.text = ""

        return cell
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

extension SearchLocationTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        let vancouverlocation = CLLocationCoordinate2DMake(  49.246292, -123.116226)
        let mapspan = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: vancouverlocation, span:mapspan)
        request.region = region
        request.naturalLanguageQuery = searchBarText
        let query = MKLocalSearch(request: request)
        query.start(completionHandler: { response, _ in
            guard let response = response else {
                return
            }
            self.Locations = response.mapItems
            self.tableView.reloadData()
        })
        
    }
    
    
    
}

//
//  AddPickEventViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-07-07.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class AddPickEventViewController: UIViewController {

    @IBOutlet weak var locationSearch: UISearchBar!
    @IBOutlet weak var dateandtimeSelector: UIDatePicker!
    @IBAction func saveButton(_ sender: Any) {
    }
    @IBOutlet weak var numberofTrees: UILabel!
    @IBAction func treeIncrementer(_ sender: Any) {
    }
    @IBOutlet weak var numberofVolunteers: UILabel!
    @IBAction func volunteerIncrementer(_ sender: Any) {
    }
    @IBOutlet weak var typeTreeSelector: UIPickerView!
    var resultSearchController:UISearchController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "SearchLocationTableViewController") as! SearchLocationTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Enter the location"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

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

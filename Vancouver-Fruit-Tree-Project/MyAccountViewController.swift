//
//  MyAccountViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Jeff Lee on 2018-07-17.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSAuthCore



class MyAccountViewController: UIViewController {

    @IBOutlet weak var myAccUsername: UILabel!
    @IBOutlet weak var myAccEmail: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let db = DatabaseInterface()
        if let username = db.getUsername(){
            myAccUsername.text = username
        }
        else {
            myAccUsername.text = "none"
        }
        
        if let email = db.getEmail(){
            myAccEmail.text = email
        }
        
        else {
            myAccEmail.text = "none"
        }
        
        self.view.isUserInteractionEnabled = true
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

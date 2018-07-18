//
//  MyAccountViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Jeff Lee on 2018-07-17.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import AWSCognitoIdentityProviderASF
import AWSDynamoDB
import AWSUserPoolsSignIn
import AWSMobileClient

class MyAccountViewController: UIViewController {

    @IBOutlet weak var myAccUsername: UILabel!
    @IBOutlet weak var myAccEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //needs to read from database
        myAccUsername.text = UIDevice.current.name
        myAccEmail.text = "test@email.com"
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

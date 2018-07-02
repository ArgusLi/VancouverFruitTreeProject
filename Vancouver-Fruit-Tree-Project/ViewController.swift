//
//  ViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Artem Gromov on 2018-06-12.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSGoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            presentAuthUIViewController()
            
        }
    }
    
    @IBAction func TestDBIndexQuery(_ sender: Any) {
        
        let DBInterface = DatabaseInterface();
        let pickArray: [PickEvents] = DBInterface.queryPickEventsByDate(date: "2018/6/29", time: "15:30")
        print("Query completed")
        print(pickArray.count)
        for x in pickArray {
            print(x._userId!)
        }
        
    }
    
    @IBAction func TestDBScan(_ sender: Any) {
        
        let DBInterface = DatabaseInterface()
        
        let pickArray = DBInterface.scanPickEvents(itemLimit: 20, maxDate: "2018/07/01")
        
        print(pickArray.count)
        for x in pickArray {
            print(x._eventDate!)
        }
        
    }
    @IBAction func TestDBQueryAndDelete(_ sender: Any) {
        
        let DBInterface = DatabaseInterface()
        let userID = AWSIdentityManager.default().identityId!
        print("User #: " + userID)
        
        let pick = DBInterface.readPickEvent(userId: userID , creationTime: "2018/7/1-14:58:33")
        var unwrappedPick: PickEvents
        if pick != nil{
            unwrappedPick = pick!
            print("userID: " + unwrappedPick._userId!)
            print("creationTime: " + unwrappedPick._creationTime!)
            
        }
        
        let result = DBInterface.deletePickEvent(itemToDelete: pick!)
        
        print("Result of delete: " + String(result))
        
    }
    
    
    @IBAction func TestDBUpload(_ sender: Any) {
        
        let DBInterface = DatabaseInterface();
        
        DBInterface.createPickEvents(eventTime: "16:45", eventDate:"2018/07/01" , latitude: 4000, longitude: 2000, teamID: "2");
        
        let d1 = "2018/07/29"
        let d2 = "2018/12/02"
        let result  = d1 > d2
        print("Evaluation of " + String(d1) + " > "  + String(d2) + " :" + String(result) )
        
        
    }
    
    @IBAction func TestDBFetch(_ sender: Any) {
        
        let DBInterface = DatabaseInterface()
        let userID = AWSIdentityManager.default().identityId!
        print("User #: " + userID)
        
        let pick = DBInterface.readPickEvent(userId: userID , creationTime: "2018/7/1-14:58:33")
        
        if pick != nil{
            let unwrappedPick = pick!
            print("userID: " + unwrappedPick._userId!)
            print("creationTime: " + unwrappedPick._creationTime!)
            
        }
        
    }
    @IBAction func signOutButton(_ sender: Any) {
        AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
            self.presentAuthUIViewController()
            
            
        })
    }
    
    func presentAuthUIViewController(){
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        config.addSignInButtonView(class: AWSGoogleSignInButton.self)
        config.backgroundColor = UIColor.white
        
        config.isBackgroundColorFullScreen = true
        config.logoImage = UIImage(named: "VFTP_LOGO_CS3-167x300")
        
        AWSAuthUIViewController.presentViewController(
            with: self.navigationController!,
            configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                if error == nil {
                    print (AWSIdentityManager.default().identityId!)
                    // SignIn succeeded.
                    print("SignIn Succeeded")
                } else {
                    // end user faced error while loggin in, take any required action here.
                }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


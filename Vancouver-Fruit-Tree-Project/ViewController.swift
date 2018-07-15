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
import SideMenu
class ViewController: UIViewController {
    //MARK - hamburger menu vars
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    @IBAction func contactUsButton(_ sender: Any) {
        let alert = UIAlertController(title: "276Harvest8@gmail.com", message: "We appreciate any comments and feedback :)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    @IBOutlet var hamburgerView: UIView!
    var hamburgerMenuIsVisible = false
    
    @IBAction func TestUserQuery(_ sender: Any) {
        print("test user query button was pressed")
        
        let DBINT = DatabaseInterface()
        
        let output = DBINT.queryUsers()
        
        if (output) != nil {
            
            print(output![0])
            
        }
        
    }
    
    
    @IBAction func TestButtonFunction(_ sender: Any) {
        
        print("test button was pressed")
        let DBINT = DatabaseInterface()
        
        DBINT.createPickEvents(eventTime: "12:00", eventDate: "2018/07/16", latitude: 40, longitude: 49, teamID: "1", address: "Test Address", treeMap: ["Apple": "1", "Cherry" : "2"])
        
        let pickQuery: [PickEvents] = DBINT.queryPickEventsByDate(date: "2018/07/16", time: "12:00")
        
        let team = Team()
        
        DBINT.createTeam(teamItem: team!, pickItem: pickQuery[0])
        
        //readPick = DBINT.readPickEvent(userId: pickQuery[0]._userId!, creationTime: pickQuery[0]._creationTime!)
        
        print("After creation call")
        
    }
    
    
    @IBAction func hamburgerButton(_ sender: Any) {
        if !hamburgerMenuIsVisible{
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
        
        else {
            dismiss(animated: true, completion: nil)
            hamburgerMenuIsVisible = false
        }
        
        UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()}) {
            
            (animationComplete) in
                print("The animation is complete!")
            
        }
        
    }
    
    //main
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            presentAuthUIViewController()
            
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


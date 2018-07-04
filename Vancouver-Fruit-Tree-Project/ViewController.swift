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
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var hamburgerMenuIsVisible = false
    
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
        self.navigationItem.rightBarButtonItem = signOutButton
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


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

    func getUsername() {
        //to check if user is logged in with Cognito... not sure if this is necessary
        let identityManager = AWSIdentityManager.default()
        let identityProvider = identityManager.credentialsProvider.identityProvider.identityProviderName
        
        if identityProvider == "cognito-identity.amazonaws.com" {
            
            let serviceConfiguration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: nil)
            let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: "7bgr1sfh851ajh0v3t65hq69q3", clientSecret: "9bllitmncjkeb9nnnvb4ei0e6vod746e7pa83hqm39nsvssqh05", poolId: "us-east-1_LXKwVfwkz")
            AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: userPoolConfiguration, forKey: "vancouverfruittreepr_userpool_MOBILEHUB_79870386")
            let pool = AWSCognitoIdentityUserPool(forKey: "vancouverfruittreepr_userpool_MOBILEHUB_79870386")
            
            if let username = pool.currentUser()?.username {
                myAccUsername.text = username
            } else {
                myAccUsername.text = "Error"
            }
        }
    }
    
    func getEmail() {
        let identityManager = AWSIdentityManager.default()
        let identityProvider = identityManager.credentialsProvider.identityProvider.identityProviderName
        if identityProvider == "cognito-identity.amazonaws.com" {
            
            let serviceConfiguration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: nil)
            let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: "7bgr1sfh851ajh0v3t65hq69q3", clientSecret: "9bllitmncjkeb9nnnvb4ei0e6vod746e7pa83hqm39nsvssqh05", poolId: "us-east-1_LXKwVfwkz")
            AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: userPoolConfiguration, forKey: "vancouverfruittreepr_userpool_MOBILEHUB_79870386")
            let pool = AWSCognitoIdentityUserPool(forKey: "vancouverfruittreepr_userpool_MOBILEHUB_79870386")
            if let userFromPool = pool.currentUser() {
                userFromPool.getDetails().continueOnSuccessWith(block: { (task) -> Any? in
                    DispatchQueue.main.async {
                        
                        if let error = task.error as NSError? {
                            print("Error getting user attributes from Cognito: \(error)")
                        } else {
                            let response = task.result
                            if let userAttributes = response?.userAttributes {
                                for attribute in userAttributes {
                                    if attribute.name == "email" {
                                        if let email = attribute.value
                                        {
                                            self.myAccEmail.text = email
                                        }
                                        else{ self.myAccEmail.text = "Email is Null"
                                            
                                        }
                                        
                                        
                                        
                                    }
                                } } } } } )
                
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            getUsername()
            getEmail()
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

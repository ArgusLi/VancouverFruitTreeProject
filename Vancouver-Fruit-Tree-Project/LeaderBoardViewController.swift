//
//  LeaderBoardViewController.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Oliver Fujiki on 2018-07-30.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UIViewController {

    @IBOutlet weak var thirdPlace: UILabel!
    @IBOutlet weak var secondPlace: UILabel!
    @IBOutlet weak var firstPlace: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var rank: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLabels()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getLeaders() -> [Users]? {
        
        let DBINT = DatabaseInterface()
        
        let LeaderArray: [Users]? = DBINT.queryUserByRoles(userRole: "Leader", itemLimit: 50)
        
        return LeaderArray
        
    }
    
    func sortLeader() -> [Users]?
    {
        var LeaderArray = getLeaders()
        //var LeaderArraySorted = [Users]()
        

        
        if LeaderArray != nil {
            
            let count = LeaderArray!.count
            print("Leader array size: " + String(count))
            
            var largerValue: Users = Users()
            
            for i in 0...count {
                for j in 1...count - 1 {
                    if LeaderArray![j-1]._yield!.intValue > LeaderArray![j]._yield!.intValue {
                        largerValue = LeaderArray![j-1]
                        LeaderArray![j-1] = LeaderArray![j]
                        LeaderArray![j] = largerValue
                    }
                }
            }
        }
        
        return LeaderArray
        
    }
    
/*    func testableSortLeader(arr: [Int]) -> Bool {
        var tArr = arr
        tArr = arr
        let count = arr.count
        var largerValue: Int
        for j in 1...count - 1 {
            if tArr[j-1] > tArr[j] {
                largerValue = arr[j-1]
                tArr[j-1] = tArr[j]
                tArr[j] = largerValue
            }
        }
        if tArr[0] == 1 {
            return true
        } else {
            return false
        }
    }

   */
    
    func changeLabels()
    {
        var Array = sortLeader()
        
        Array?.reverse()
        
        firstPlace.text = Array![0]._userId
        
        secondPlace.text = Array![1]._userId
        
        thirdPlace.text = Array![2]._userId
        
        let dbi = DatabaseInterface()
        
        let userInfo: Users = dbi.queryUserInfo(userId: dbi.getUsername()!)!
        
        userName.text = userInfo._userId
        
        if userInfo._role == "Leader"{
            let yourIndex = Array?.index(of: userInfo)
            
            rank.text = String(yourIndex! + 1)
        }
        else{
            rank.text = "N/A"
        }
        
    
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

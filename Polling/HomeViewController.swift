//
//  HomeViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/5/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser = AnyObject?()
    var loggedInUserData = AnyObject?()
    
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var btCreatePoll: UIButton!
    
    var polls = [AnyObject?]()
    var answers = AnyObject?()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btCreatePoll.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        btCreatePoll.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        btCreatePoll.layer.shadowOpacity = 1.0
        btCreatePoll.layer.shadowRadius = 10.0
        btCreatePoll.layer.masksToBounds = false
        btCreatePoll.layer.cornerRadius = 3.0
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        
        //get the logged in users details
        self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).observeSingleEventOfType(.Value) { (snapshot:FIRDataSnapshot) in
            
            //store the logged in users details into the variable
            self.loggedInUserData = snapshot
            print(self.loggedInUserData)
            
            //get all the polls that are made by the user
            
            self.databaseRef.child("polls/\(self.loggedInUser!.uid)").observeEventType(.ChildAdded, withBlock: { (snapshot:FIRDataSnapshot) in
                
                self.answers = snapshot
                self.polls.append(snapshot)
                
                self.homeTableView.insertRowsAtIndexPaths([NSIndexPath(forRow:0,inSection:0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                
                self.aivLoading.stopAnimating()
                
            }){(error) in
                
                print(error.localizedDescription)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.polls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: HomeViewTableViewCell = tableView.dequeueReusableCellWithIdentifier("PostpollsCell", forIndexPath: indexPath) as! HomeViewTableViewCell
        
        let poll = polls[(self.polls.count-1) - indexPath.row]!.value["question"] as! String
        
        cell.configure(nil,name:self.loggedInUserData!.value["name"] as! String,poll: poll,answer1: self.answers!.value["answerone"] as! String,answer2: self.answers!.value["answertwo"] as! String,answer3: self.answers!.value["answerthree"] as! String,answer4: self.answers!.value["answerfour"] as! String)
        
        return cell
    }

}

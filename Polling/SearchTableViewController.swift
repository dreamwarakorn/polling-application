//
//  SearchTableViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/21/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    @IBOutlet var searchTableView: UITableView!
    
    var loggedInUser: FIRUser?
    
    
    var databaseRef = FIRDatabase.database().reference()
    
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var resultSearchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        databaseRef.child("user_profile").queryOrderedByChild("name").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "uid")
            
            if(key == self.loggedInUser?.uid)
            {
                print("same as logged in user")
            }else
            {
                self.usersArray.append(snapshot)
                self.searchTableView.insertRowsAtIndexPaths([
                    NSIndexPath(forRow: self.usersArray.count-1, inSection: 0)
                    ], withRowAnimation: .Automatic)
            }
            
        })
        
        
        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.resultSearchController.active)
        {
            return self.filteredUsers.count
        }
        else
        {
            return self.usersArray.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as UITableViewCell?
        
        let user : NSDictionary?
        
        if (self.resultSearchController.active){
            
            user = filteredUsers[indexPath.row]
        }
        else
        {
            user = self.usersArray[indexPath.row]
        }
        
        cell!.textLabel?.text = user?["name"] as? String
        cell!.detailTextLabel?.text = user?["username"] as? String
        
        return cell!
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        
        self.filteredUsers.removeAll(keepCapacity: false)
        
        filterContent(self.resultSearchController.searchBar.text!)
        
    }
    
    func filterContent(searchText:String)
    {
        self.filteredUsers = self.usersArray.filter{ user in
            
            let username = user!["name"] as? String
            
            return username!.lowercaseString.containsString(searchText.lowercaseString)
            
        }
        
        tableView.reloadData()
    }
    
}

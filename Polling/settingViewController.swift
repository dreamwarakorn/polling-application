//
//  settingViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 10/27/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class settingViewController: UITableViewController {
    
    @IBOutlet weak var nameDetail: UILabel!
    @IBOutlet weak var usernameDetail: UILabel!
    @IBOutlet weak var emailDetail: UILabel!
    
    var loggedInUser = AnyObject?()
    var databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).observeSingleEventOfType(.Value) { (snapshot:FIRDataSnapshot) in
            
            self.nameDetail.text = snapshot.value!["name"] as? String
            self.usernameDetail.text = snapshot.value!["username"] as? String
            self.emailDetail.text = snapshot.value!["email"] as? String
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }

    @IBAction func deleteAction(sender: AnyObject) {
        if let user = FIRAuth.auth()?.currentUser {
            let alert = UIAlertController(title: "Delete Account", message: "[\(user.email!)] will be deleted. This operation can not undo. Are you sure?", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
            let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default) { (action: UIAlertAction) in user.deleteWithCompletion({ (error) in
                    if let error = error
                    {
                        let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "", message: "[\(user.email!)] was deleted", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                        {(action: UIAlertAction)-> Void in
                            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.logout()
                        }
                        alert.addAction(defaultAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Log Out of Polling?", message: "", preferredStyle: .Alert)
        let Cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default)
        {(action: UIAlertAction)-> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let Ok = UIAlertAction(title: "Log Out", style: UIAlertActionStyle.Default)
        {(action: UIAlertAction)-> Void in
            try! FIRAuth.auth()?.signOut()
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.logout()
        }
        
        alert.addAction(Cancel)
        alert.addAction(Ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}

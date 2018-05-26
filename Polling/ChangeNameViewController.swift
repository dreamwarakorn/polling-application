//
//  ChangeNameViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/10/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class ChangeNameViewController: UITableViewController {

    @IBOutlet weak var txtChangeName: UITextField!
    
    var loggedInUser = AnyObject?()
    var databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).observeSingleEventOfType(.Value) { (snapshot:FIRDataSnapshot) in
            
            self.txtChangeName.text = snapshot.value!["name"] as? String
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveNameAction(sender: AnyObject) {
        
        if self.txtChangeName.text == ""
        {
            let alertController = UIAlertController(title: "", message: "Please enter Name", preferredStyle: .Alert)
            let defaultActon = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultActon)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).child("name").setValue(self.txtChangeName.text)
            self.navigationController?.popViewControllerAnimated(true);
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}

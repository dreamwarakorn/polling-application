//
//  ChangeEmailViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/10/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class ChangeEmailViewController: UITableViewController {

    @IBOutlet weak var txtChangeEmail: UITextField!
    
    var loggedInUser = AnyObject?()
    var databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).observeSingleEventOfType(.Value) { (snapshot:FIRDataSnapshot) in
            
            self.txtChangeEmail.text = snapshot.value!["email"] as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveEmailAction(sender: AnyObject) {
        
        if self.txtChangeEmail.text == ""
        {
            let alertController = UIAlertController(title: "", message: "Please enter Email", preferredStyle: .Alert)
            let defaultActon = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultActon)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            let user = FIRAuth.auth()?.currentUser
            
            user?.updateEmail(txtChangeEmail.text!) { error in
                
                if error != nil {
                    let alertController = UIAlertController(title: "Oop!", message: (error?.localizedDescription)!, preferredStyle: .Alert)
                    let defaultActon = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertController.addAction(defaultActon)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).child("email").setValue(self.txtChangeEmail.text)
                    
                    self.navigationController?.popViewControllerAnimated(true);
                }
            }

        }
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

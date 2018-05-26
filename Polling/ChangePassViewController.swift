//
//  ChangePassViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 10/30/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class ChangePassViewController: UITableViewController {

    @IBOutlet weak var txtNewpass: UITextField!
    @IBOutlet weak var txtAgainpass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }
        
    @IBAction func doneAction(sender: AnyObject) {
        if self.txtNewpass.text == ""
        {
            let alertController = UIAlertController(title: "", message: "Please enter new password", preferredStyle: .Alert)
            let defaultActon = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultActon)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            if self.txtNewpass.text == self.txtAgainpass.text {
                let user = FIRAuth.auth()?.currentUser
                
                user?.updatePassword(txtNewpass.text!) { error in
                    
                    if error != nil {
                        let alertController = UIAlertController(title: "Oop!", message: (error?.localizedDescription)!, preferredStyle: .Alert)
                        let defaultActon = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alertController.addAction(defaultActon)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        
                        self.navigationController?.popViewControllerAnimated(true);
                    }
    
                }

            }
            else
            {
                let alertController = UIAlertController(title: "", message: "Password do not match", preferredStyle: .Alert)
                let defaultActon = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(defaultActon)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        
        }
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

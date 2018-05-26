//
//  ForgetViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 10/29/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class ForgetViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btForget: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btForget.layer.borderWidth = 0.8
        btForget.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func forgetAction(sender: AnyObject)
    {
        if self.txtEmail.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email", preferredStyle: .Alert)
            let defaultActon = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultActon)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            FIRAuth.auth()?.sendPasswordResetWithEmail(self.txtEmail.text!, completion: {(error)in
                
                var title = ""
                var message = ""
                
                if error != nil
                {
                    title = "Oop!"
                    message = (error?.localizedDescription)!
                }
                else
                {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.txtEmail.text = ""
                    
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let defaultActon = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(defaultActon)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

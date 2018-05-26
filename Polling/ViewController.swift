//
//  ViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 10/26/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btLogin: UIButton!
    @IBOutlet weak var btForgot: UIButton!
    @IBOutlet weak var btSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btLogin.layer.borderWidth = 0.8
        btLogin.layer.borderColor = UIColor.whiteColor().CGColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(sender: AnyObject) {
        if self.txtUser.text == "" || self.txtPass.text == "" {
            let alert = UIAlertController(title: "Message", message: "Please enter an email and password", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        FIRAuth.auth()?.signInWithEmail(txtUser.text!, password: txtPass.text!, completion: { (user, error) in
            if error != nil{
                let alert = UIAlertController(title: "Oop!", message: error?.localizedDescription, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(defaultAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            }
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}


//
//  SignupViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 10/27/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignupViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btSignup: UIButton!
    
    var databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btSignup.layer.borderWidth = 0.8
        btSignup.layer.borderColor = UIColor.whiteColor().CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupAction(sender: AnyObject)
    {
        if self.txtEmail.text == "" || self.txtPassword.text == "" || self.txtUsername.text == "" || self.txtName.text == "" {
            let alert = UIAlertController(title: "Message", message: "Please fill in all required information.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        FIRAuth.auth()?.createUserWithEmail(txtEmail.text!, password: txtPassword.text!, completion: { (user, error) in
            if error != nil{
                let alert = UIAlertController(title: "Oop!", message: error?.localizedDescription, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(defaultAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
                FIRAuth.auth()?.signInWithEmail(self.txtEmail.text!, password: self.txtPassword.text!, completion: {(user, error) in
                    
                    if(error == nil)
                    {
                        self.databaseRef.child("user_profile").child((user?.uid)!).child("email").setValue(self.txtEmail.text)

                        self.databaseRef.child("username").child(self.txtUsername.text!).observeSingleEventOfType(.Value, withBlock: {(snapshot:FIRDataSnapshot) in
                            
                            if(!snapshot.exists())
                            {
                                
                                
                                //update the handle in the user_profiles and in the handles node
                                
                                self.databaseRef.child("user_profile").child((user?.uid)!).child("username").setValue(self.txtUsername.text!.lowercaseString)
                                
                                //update the name of the user
                                
                                self.databaseRef.child("user_profile").child((user?.uid)!).child("name").setValue(self.txtName.text!)
                                
                                
                                //update the handle in the handle node
                                
                                self.databaseRef.child("username").child(self.txtUsername.text!.lowercaseString).setValue((user?.uid)!)
                                
                                //send the user to home screen
                                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                appDelegate.login()
                                
                                
                            }
                            else
                            {
                                
                            }
                            
                            
                        })
                        

                    }
                })
                
            }
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}

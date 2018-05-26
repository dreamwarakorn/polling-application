//
//  addPollsViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 10/27/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class addPollsViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var txtAnswerOne: UITextField!
    @IBOutlet weak var txtAnswerTwo: UITextField!
    @IBOutlet weak var txtAnswerThree: UITextField!
    @IBOutlet weak var txtAnswerFour: UITextField!
    @IBOutlet weak var imagePolls: UIImageView!
    
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser = AnyObject?()
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        questionTextView.textContainerInset = UIEdgeInsetsMake(30, 20, 20, 20)
        questionTextView.text = "Ask a question..."
        questionTextView.textColor = UIColor.lightGrayColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true;
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true
            , completion: nil)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(questionTextView.textColor == UIColor.lightGrayColor())
        {
            questionTextView.text = ""
            questionTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }

    @IBAction func postAction(sender: AnyObject) {
        
        let key = self.databaseRef.child("polls").childByAutoId().key
        
        //let storageRef = FIRStorage.storage().reference()
        //let pictureStorageRef = storageRef.child("user_profile/\(self.loggedInUser!.uid)/media/\(key)")
        
        //let lowResImageData = UIImageJPEGRepresentation(imagePolls.image!, 0.50)
        
        if(questionTextView.text.characters.count>0)
        {
            let childUpdates = ["/polls/\(self.loggedInUser!.uid)/\(key)/question":self.questionTextView.text,
                                "/polls/\(self.loggedInUser!.uid)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)","/polls/\(self.loggedInUser!.uid)/\(key)/answerone":self.txtAnswerOne.text,"/polls/\(self.loggedInUser!.uid)/\(key)/answertwo":self.txtAnswerTwo.text,"/polls/\(self.loggedInUser!.uid)/\(key)/answerthree":self.txtAnswerThree.text,"/polls/\(self.loggedInUser!.uid)/\(key)/answerfour":self.txtAnswerFour.text]
            
            self.databaseRef.updateChildValues(childUpdates)
            
            dismissViewControllerAnimated(true, completion: nil)
        }
        /*if(imagePolls.image != nil)
        {
            let uploadTask = pictureStorageRef.putData(lowResImageData!,metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    let childUpdates = ["/polls/\(self.loggedInUser!.uid)/\(key)/question":self.questionTextView.text,
                                        "/polls/\(self.loggedInUser!.uid)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)","/polls/\(self.loggedInUser!.uid)/\(key)/answerone":self.txtAnswerOne.text,"/polls/\(self.loggedInUser!.uid)/\(key)/answertwo":self.txtAnswerTwo.text,"/polls/\(self.loggedInUser!.uid)/\(key)/answerthree":self.txtAnswerThree.text,"/polls/\(self.loggedInUser!.uid)/\(key)/answerfour":self.txtAnswerFour.text,"/polls/\(self.loggedInUser!.uid)/\(key)/picture":downloadUrl!.absoluteString]
                    
                    self.databaseRef.updateChildValues(childUpdates)
                }
                
            }
            dismissViewControllerAnimated(true, completion: nil)
        }*/
        
    }
    
    @IBAction func selectImageFromPhotos(sender: AnyObject) {
        
        //open the photo gallery
        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum)
        {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .SavedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.imagePolls.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

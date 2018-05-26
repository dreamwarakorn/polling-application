//
//  profileViewController.swift
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

class profileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var txtProfile: UILabel!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    @IBOutlet weak var homeTableView: UITableView!
    
    @IBOutlet weak var txtCountPolls: UIButton!
    
    var loggedInUser = AnyObject?()
    var databaseRef = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference()
    var loggedInUserData = AnyObject?()
    
    var polls = [AnyObject?]()
    var answers = AnyObject?()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
        self.userImageView.layer.masksToBounds = true
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).observeSingleEventOfType(.Value) { (snapshot:FIRDataSnapshot) in
            
            self.txtProfile.text = snapshot.value!["name"] as? String
            
            var titleButton: UIButton = UIButton(frame: CGRectMake(0, 0, 100, 32))
            titleButton.setTitle(self.txtProfile.text, forState: UIControlState.Normal)
            titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            self.navigationItem.titleView = titleButton
            
            if(snapshot.value!["profile_pic"] !== nil)
            {
                let databaseProfilePic = snapshot.value!["profile_pic"]
                    as! String
                
                let data = NSData(contentsOfURL: NSURL(string: databaseProfilePic)!)
                self.setProfilePicture(self.userImageView,imageToSet:UIImage(data:data!)!)
            }
            
            self.imageLoader.stopAnimating()
        }
        
        
        //get the logged in users details
        self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).observeSingleEventOfType(.Value) { (snapshot:FIRDataSnapshot) in
            
            //store the logged in users details into the variable
            self.loggedInUserData = snapshot
            print(self.loggedInUserData)
            
            //get all the tweets that are made by the user
            
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
    
    internal func setProfilePicture(imageView:UIImageView,imageToSet:UIImage)
    {
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    @IBAction func choosePicture(sender: UITapGestureRecognizer) {
        let myActionSheet = UIAlertController(title:"Change Profile Photo",message:"",preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let photoGallery = UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.Default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.SavedPhotosAlbum)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.presentViewController(self.imagePicker, animated: true
                    , completion: nil)
            }
        }
        
        let camera = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.imagePicker.allowsEditing = true
                
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        myActionSheet.addAction(camera)
        myActionSheet.addAction(photoGallery)
        
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(myActionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.imageLoader.startAnimating()
        setProfilePicture(self.userImageView,imageToSet: image)
        
        if let imageData: NSData = UIImagePNGRepresentation(self.userImageView.image!)!
        {
            
            let profilePicStorageRef = storageRef.child("user_profile/\(self.loggedInUser!.uid)/profile_pic")
            
            let uploadTask = profilePicStorageRef.putData(imageData, metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).child("profile_pic").setValue(downloadUrl!.absoluteString)
                }
                else
                {
                    print(error?.localizedDescription)
                }
                
                self.imageLoader.stopAnimating()
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.polls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ProfileViewTableViewCell = tableView.dequeueReusableCellWithIdentifier("PostpollsCell2", forIndexPath: indexPath) as! ProfileViewTableViewCell
        
        let poll = polls[(self.polls.count-1) - indexPath.row]!.value["question"] as! String
        
        cell.configure(nil,name:self.loggedInUserData!.value["name"] as! String,poll: poll,answer1: self.answers!.value["answerone"] as! String,answer2: self.answers!.value["answertwo"] as! String,answer3: self.answers!.value["answerthree"] as! String,answer4: self.answers!.value["answerfour"] as! String)
        
        return cell
    }
    
}

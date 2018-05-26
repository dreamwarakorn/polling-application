//
//  ProfileViewTableViewCell.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/5/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

public class ProfileViewTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poll: UITextView!
    
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    @IBOutlet weak var answer1Bar: UIProgressView!
    @IBOutlet weak var answer2Bar: UIProgressView!
    @IBOutlet weak var answer3Bar: UIProgressView!
    @IBOutlet weak var answer4Bar: UIProgressView!
    
    @IBOutlet weak var lbPerAnswer1: UILabel!
    @IBOutlet weak var lbPerAnswer2: UILabel!
    @IBOutlet weak var lbPerAnswer3: UILabel!
    @IBOutlet weak var lbPerAnswer4: UILabel!
    
    @IBOutlet weak var lbAnswer1: UILabel!
    @IBOutlet weak var lbAnswer2: UILabel!
    @IBOutlet weak var lbAnswer3: UILabel!
    @IBOutlet weak var lbAnswer4: UILabel!
    
    var loggedInUser = AnyObject?()
    var databaseRef = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference()
    
    var counter: Float = 0.0{
        didSet {
            let fractionalProgress = counter / 100.0
            let animated = counter != 0
            
            answer1Bar.setProgress(fractionalProgress, animated: animated)
            answer2Bar.setProgress(fractionalProgress, animated: animated)
            answer3Bar.setProgress(fractionalProgress, animated: animated)
            answer4Bar.setProgress(fractionalProgress, animated: animated)
            lbPerAnswer1.text = ("\(counter*10)%")
        }
    }
    var counter2: Float = 0.0{
        didSet {
            let fractionalProgress = counter2 / 100.0
            let animated = counter2 != 0
            
            answer1Bar.setProgress(fractionalProgress, animated: animated)
            answer2Bar.setProgress(fractionalProgress, animated: animated)
            answer3Bar.setProgress(fractionalProgress, animated: animated)
            answer4Bar.setProgress(fractionalProgress, animated: animated)
            lbPerAnswer2.text = ("\(counter2*10)%")
        }
    }
    var counter3: Float = 0.0{
        didSet {
            let fractionalProgress = counter3 / 100.0
            let animated = counter3 != 0
            
            answer1Bar.setProgress(fractionalProgress, animated: animated)
            answer2Bar.setProgress(fractionalProgress, animated: animated)
            answer3Bar.setProgress(fractionalProgress, animated: animated)
            answer4Bar.setProgress(fractionalProgress, animated: animated)
            lbPerAnswer3.text = ("\(counter3*10)%")
        }
    }
    var counter4: Float = 0.0{
        didSet {
            let fractionalProgress = counter4 / 100.0
            let animated = counter4 != 0
            
            answer1Bar.setProgress(fractionalProgress, animated: animated)
            answer2Bar.setProgress(fractionalProgress, animated: animated)
            answer3Bar.setProgress(fractionalProgress, animated: animated)
            answer4Bar.setProgress(fractionalProgress, animated: animated)
            lbPerAnswer4.text = ("\(counter4*10)%")
        }
    }

    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.counter = 0
        self.counter2 = 0
        self.counter3 = 0
        self.counter4 = 0
        self.answer1Bar.setProgress(0, animated: true)
        self.answer1Bar.hidden = true
        self.lbPerAnswer1.hidden = true
        self.lbAnswer1.hidden = true
        self.answer2Bar.setProgress(0, animated: true)
        self.answer2Bar.hidden = true
        self.lbPerAnswer2.hidden = true
        self.lbAnswer2.hidden = true
        self.answer3Bar.setProgress(0, animated: true)
        self.answer3Bar.hidden = true
        self.lbPerAnswer3.hidden = true
        self.lbAnswer3.hidden = true
        self.answer4Bar.setProgress(0, animated: true)
        self.answer4Bar.hidden = true
        self.lbPerAnswer4.hidden = true
        self.lbAnswer4.hidden = true
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).observeSingleEventOfType(.Value) { (snapshot:FIRDataSnapshot) in
            
            if(snapshot.value!["profile_pic"] !== nil)
            {
                let databaseProfilePic = snapshot.value!["profile_pic"]
                    as! String
                
                let data = NSData(contentsOfURL: NSURL(string: databaseProfilePic)!)
                self.setProfilePicture(self.profilePic,imageToSet:UIImage(data:data!)!)
            }
            
            
        }

        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true
        
        answer1.layer.borderWidth = 0.8
        answer1.layer.borderColor = UIColor.blackColor().CGColor
        answer2.layer.borderWidth = 0.8
        answer2.layer.borderColor = UIColor.blackColor().CGColor
        answer3.layer.borderWidth = 0.8
        answer3.layer.borderColor = UIColor.blackColor().CGColor
        answer4.layer.borderWidth = 0.8
        answer4.layer.borderColor = UIColor.blackColor().CGColor
        
        answer1Bar.transform = CGAffineTransformScale(answer1Bar.transform, 1, 8)
        answer2Bar.transform = CGAffineTransformScale(answer2Bar.transform, 1, 8)
        answer3Bar.transform = CGAffineTransformScale(answer3Bar.transform, 1, 8)
        answer4Bar.transform = CGAffineTransformScale(answer4Bar.transform, 1, 8)
    }
    
    internal func setProfilePicture(imageView:UIImageView,imageToSet:UIImage)
    {
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    public func configure(profilePic:String?,name:String,poll:String,answer1:String,answer2:String,answer3:String,answer4:String)
    {
        
        self.poll.text = poll
        self.name.text = name
        self.answer1.setTitle(answer1, forState: .Normal)
        self.answer2.setTitle(answer2, forState: .Normal)
        self.answer3.setTitle(answer3, forState: .Normal)
        self.answer4.setTitle(answer4, forState: .Normal)
        self.lbAnswer1.text = answer1
        self.lbAnswer2.text = answer2
        self.lbAnswer3.text = answer3
        self.lbAnswer4.text = answer4
        
        if(answer2 == "" && answer3 == "" && answer4 == "")
        {
            self.answer2.hidden = true
            self.answer3.hidden = true
            self.answer4.hidden = true
        }
        else if(answer3 == "" && answer4 == "")
        {
            self.answer3.hidden = true
            self.answer4.hidden = true
        }
        else if(answer4 == "")
        {
            self.answer4.hidden = true
        }
        
        if((profilePic) != nil)
        {
            let imageData = NSData(contentsOfURL: NSURL(string:profilePic!)!)
            self.profilePic.image = UIImage(data:imageData!)
        }
        else
        {
            self.profilePic.image = UIImage(named:"user-placeholder.jpg")
        }
        
    }
    
    @IBAction func answer1Action(sender: AnyObject) {
        self.answer1.hidden = true
        self.answer2.hidden = true
        self.answer1Bar.hidden = false
        self.lbPerAnswer1.hidden = false
        self.lbAnswer1.hidden = false
        self.answer2Bar.hidden = false
        self.lbPerAnswer2.hidden = false
        self.lbAnswer2.hidden = false
        
        if(self.answer3.hidden == true)
        {
            self.answer3Bar.hidden = true
            self.lbPerAnswer3.hidden = true
            self.lbAnswer3.hidden = true
            self.answer4Bar.hidden = true
            self.lbPerAnswer4.hidden = true
            self.lbAnswer4.hidden = true
            
        }else
        {
            if(self.answer4.hidden == true){
                self.answer3Bar.hidden = false
                self.lbPerAnswer3.hidden = false
                self.lbAnswer3.hidden = false
                self.answer3.hidden = true
                self.answer4Bar.hidden = true
                self.lbPerAnswer4.hidden = true
                self.lbAnswer4.hidden = true
                self.answer4.hidden = true
            }
            else if(answer4 != nil){
                self.answer3Bar.hidden = false
                self.lbPerAnswer3.hidden = false
                self.lbAnswer3.hidden = false
                self.answer3.hidden = true
                self.answer4Bar.hidden = false
                self.lbPerAnswer4.hidden = false
                self.lbAnswer4.hidden = false
                self.answer4.hidden = true
            }
            
        }
        
        lbPerAnswer1.text = "0%"
        self.counter += 0.1
        if (self.counter == 1.0){
            self.answer1Bar.progress = 1.0
            return
        }
        self.answer1Bar.progress = counter;
    }
    
    @IBAction func answer2Action(sender: AnyObject) {
        self.answer1.hidden = true
        self.answer2.hidden = true
        self.answer1Bar.hidden = false
        self.lbPerAnswer1.hidden = false
        self.lbAnswer1.hidden = false
        self.answer2Bar.hidden = false
        self.lbPerAnswer2.hidden = false
        self.lbAnswer2.hidden = false
        
        if(self.answer3.hidden == true)
        {
            self.answer3Bar.hidden = true
            self.lbPerAnswer3.hidden = true
            self.lbAnswer3.hidden = true
            self.answer4Bar.hidden = true
            self.lbPerAnswer4.hidden = true
            self.lbAnswer4.hidden = true
            
        }else
        {
            if(self.answer4.hidden == true){
                self.answer3Bar.hidden = false
                self.lbPerAnswer3.hidden = false
                self.lbAnswer3.hidden = false
                self.answer3.hidden = true
                self.answer4Bar.hidden = true
                self.lbPerAnswer4.hidden = true
                self.lbAnswer4.hidden = true
                self.answer4.hidden = true
            }
            else if(answer4 != nil){
                self.answer3Bar.hidden = false
                self.lbPerAnswer3.hidden = false
                self.lbAnswer3.hidden = false
                self.answer3.hidden = true
                self.answer4Bar.hidden = false
                self.lbPerAnswer4.hidden = false
                self.lbAnswer4.hidden = false
                self.answer4.hidden = true
            }
            
        }
        
        
        lbPerAnswer2.text = "0%"
        self.counter2 += 0.1
        if (self.counter2 == 1.0){
            self.answer2Bar.progress = 1.0
            return
        }
        self.answer2Bar.progress = counter2;
    }
    
    @IBAction func answer3Action(sender: AnyObject) {
        self.answer1.hidden = true
        self.answer2.hidden = true
        self.answer1Bar.hidden = false
        self.lbPerAnswer1.hidden = false
        self.lbAnswer1.hidden = false
        self.answer2Bar.hidden = false
        self.lbPerAnswer2.hidden = false
        self.lbAnswer2.hidden = false
        
        if(self.answer3.hidden == true)
        {
            self.answer3Bar.hidden = true
            self.lbPerAnswer3.hidden = true
            self.lbAnswer3.hidden = true
            self.answer4Bar.hidden = true
            self.lbPerAnswer4.hidden = true
            self.lbAnswer4.hidden = true
            
        }else
        {
            if(self.answer4.hidden == true){
                self.answer3Bar.hidden = false
                self.lbPerAnswer3.hidden = false
                self.lbAnswer3.hidden = false
                self.answer3.hidden = true
                self.answer4Bar.hidden = true
                self.lbPerAnswer4.hidden = true
                self.lbAnswer4.hidden = true
                self.answer4.hidden = true
            }
            else if(answer4 != nil){
                self.answer3Bar.hidden = false
                self.lbPerAnswer3.hidden = false
                self.lbAnswer3.hidden = false
                self.answer3.hidden = true
                self.answer4Bar.hidden = false
                self.lbPerAnswer4.hidden = false
                self.lbAnswer4.hidden = false
                self.answer4.hidden = true
            }
            
        }
        
        lbPerAnswer3.text = "0%"
        self.counter3 += 0.1
        if (self.counter3 == 1.0){
            self.answer3Bar.progress = 1.0
            return
        }
        self.answer3Bar.progress = counter3;
        
    }
    
    @IBAction func answer4Action(sender: AnyObject) {
        self.answer1.hidden = true
        self.answer2.hidden = true
        self.answer1Bar.hidden = false
        self.lbPerAnswer1.hidden = false
        self.lbAnswer1.hidden = false
        self.answer2Bar.hidden = false
        self.lbPerAnswer2.hidden = false
        self.lbAnswer2.hidden = false
        
        if(self.answer3.hidden == true)
        {
            self.answer3Bar.hidden = true
            self.lbPerAnswer3.hidden = true
            self.lbAnswer3.hidden = true
            self.answer4Bar.hidden = true
            self.lbPerAnswer4.hidden = true
            self.lbAnswer4.hidden = true
            
        }else
        {
            if(self.answer4.hidden == true){
                self.answer3Bar.hidden = false
                self.lbPerAnswer3.hidden = false
                self.lbAnswer3.hidden = false
                self.answer3.hidden = true
                self.answer4Bar.hidden = true
                self.lbPerAnswer4.hidden = true
                self.lbAnswer4.hidden = true
                self.answer4.hidden = true
            }
            else if(answer4 != nil){
                self.answer3Bar.hidden = false
                self.lbPerAnswer3.hidden = false
                self.lbAnswer3.hidden = false
                self.answer3.hidden = true
                self.answer4Bar.hidden = false
                self.lbPerAnswer4.hidden = false
                self.lbAnswer4.hidden = false
                self.answer4.hidden = true
            }
            
        }
        
        lbPerAnswer4.text = "0%"
        self.counter4 += 0.1
        if (self.counter4 == 1.0){
            self.answer4Bar.progress = 1.0
            return
        }
        self.answer4Bar.progress = counter4;
        
    }

    
}


//
//  UserProfileViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/7/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {

    var loggedInUser: FIRUser?
    var otherUser: NSDictionary?
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUserData: NSDictionary?
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).observeEventType(.Value, withBlock: {(snapshot) in
            
            self.loggedInUserData = snapshot.value as? NSDictionary
            self.loggedInUserData?.setValue(self.loggedInUser!.uid, forKey: "uid")
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
        self.databaseRef.child("user_profile").child(self.otherUser?["uid"] as! String).observeEventType(.Value, withBlock: {(snapshot) in
            
            let uid = self.otherUser?["uid"] as! String
            self.otherUser = snapshot.value as? NSDictionary
            self.otherUser?.setValue(uid, forKey: "uid")
            
        }) {(error) in
            print(error.localizedDescription)
        }

        self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).child(self.otherUser?["uid"] as! String).observeEventType(.Value, withBlock: {(snapshot) in
            
            if(snapshot.exists())
            {
                self.followButton.setTitle("UnFollow", forState: .Normal)
            }else
            {
                self.followButton.setTitle("Follow", forState: .Normal)
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
        self.name.text = self.otherUser?["name"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapFollow(sender: AnyObject) {
        let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
        let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
        
        if (self.followButton.titleLabel?.text == "Follow") {
            
            let followersData = ["name":self.loggedInUserData?["name"] as! String,
                                 "username":self.loggedInUserData?["username"] as! String,
                                 "profile_pic":"\(self.loggedInUserData?["profile_pic"])"]
            
            let followingData = ["name":self.otherUser?["name"] as! String,
                                 "username":self.otherUser?["username"] as! String,
                                 "profile_pic":"\(self.otherUser?["profile_pic"])"]
            
            let childUpdates = [followersRef:followersData,
                                followingRef:followingData]
            
            
            self.databaseRef.updateChildValues(childUpdates)
            
            let followersCount:Int?
            let followingCount:Int?
            if(self.otherUser?["followersCount"] == nil)
            {
                followersCount=1
            }
            else
            {
                followersCount = self.otherUser?["followersCount"] as! Int + 1
            }
            
            if(self.loggedInUserData?["followingCount"] == nil)
            {
                followingCount = 1
            }
            else
            {
                
                followingCount = self.loggedInUserData?["followingCount"] as! Int + 1
            }
            
            self.databaseRef.child("user_profile").child(self.loggedInUser!.uid).child("followingCount").setValue(followingCount!)
            self.databaseRef.child("user_profile").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(followersCount!)
            
            
        }
        else
        {
            self.databaseRef.child("user_profile").child(self.loggedInUserData?["uid"] as! String).child("followingCount").setValue(self.loggedInUserData!["followingCount"] as! Int - 1)
            self.databaseRef.child("user_profile").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(self.otherUser!["followersCount"] as! Int - 1)
            
            let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
            let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
            
            
            let childUpdates = [followingRef:NSNull(),followersRef:NSNull()]
            self.databaseRef.updateChildValues(childUpdates)
            
            
        }

    }

}

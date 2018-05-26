//
//  PushNotificationTableViewCell.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/8/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit
import Firebase

class PushNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var statusUser: UIImageView!
    @IBOutlet weak var questionTopic: UIButton!
    
    var loggedInUser = AnyObject?()
    var databaseRef = FIRDatabase.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(poll:String)
    {
        self.questionTopic.setTitle(poll, forState: .Normal)
        
        
    }

}

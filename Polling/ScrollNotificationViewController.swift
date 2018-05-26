//
//  ScrollNotificationViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/19/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit

class ScrollNotificationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let V1 = self.storyboard?.instantiateViewControllerWithIdentifier("PushNotification") as UIViewController!
        self.addChildViewController(V1)
        self.scrollView.addSubview(V1.view)
        V1.didMoveToParentViewController(self)
        V1.view.frame = scrollView.bounds
        
        let V2 = self.storyboard?.instantiateViewControllerWithIdentifier("PushRecent") as UIViewController!
        self.addChildViewController(V2)
        self.scrollView.addSubview(V2.view)
        V2.didMoveToParentViewController(self)
        V2.view.frame = scrollView.bounds
        
        var V2Frame: CGRect = V2.view.frame
        V2Frame.origin.x = self.view.frame.width
        V2.view.frame = V2Frame
        
        self.scrollView.contentSize = CGSizeMake((self.view.frame.width) * 2, (self.view.frame.height))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

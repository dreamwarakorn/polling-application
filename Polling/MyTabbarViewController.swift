//
//  MyTabbarViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/23/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit

class MyTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 40
        tabFrame.origin.y = self.view.frame.size.height - 40
        self.tabBar.frame = tabFrame
    }

}

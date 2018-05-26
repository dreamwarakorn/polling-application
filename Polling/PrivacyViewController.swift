//
//  PrivacyViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/23/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var privacyWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = NSURL (string: "http://inewz.site/ios/private.html")
        let requestObj = NSURLRequest(URL: url!)
        privacyWebView.loadRequest(requestObj)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

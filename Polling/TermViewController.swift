//
//  TermViewController.swift
//  Polling
//
//  Created by Warakorn Rungseangthip on 11/10/2559 BE.
//  Copyright © 2559 Warakorn Rungseangthip. All rights reserved.
//

import UIKit

class TermViewController: UIViewController {

    @IBOutlet weak var termWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = NSURL (string: "http://inewz.site/ios/term.html")
        let requestObj = NSURLRequest(URL: url!)
        termWebView.loadRequest(requestObj)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

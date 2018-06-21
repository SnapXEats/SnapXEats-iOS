//
//  PrivacyPolicyViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 21/06/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import WebKit

class PrivacyPolicyViewController: UIViewController, StoryboardLoadable {
      var privacyWebView: WKWebView?
    
    override func viewDidLoad() {
        initView()
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func creatWKWebview() {
        let webConfiguration = WKWebViewConfiguration()
        privacyWebView = WKWebView(frame: .init(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 55, width: self.view.frame.width, height: self.view.frame.height), configuration: webConfiguration)
        if let url = Bundle.main.url(forResource: "PrivacyPolicySnapXEats", withExtension: "html"), let webView = privacyWebView {
            webView.loadFileURL(url, allowingReadAccessTo: url)
            self.view.addSubview(webView)
            self.view.sendSubview(toBack: webView)
        }
        
    }
    
    func initView() {
        creatWKWebview()
    }
}

//
//  InstagramViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 05/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import WebKit
enum InstagramEnum {
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_CLIENT_ID = "e8454500a65241c3a8f833fee63a5043"
    static let INSTAGRAM_CLIENTSERCRET = "4464a69c1fce432f9f00dd0f05591f12"
    static let INSTAGRAM_REDIRECT_URI = "http://www.snapx.com"
    static let INSTAGRAM_ACCESS_TOKEN = "access_token"
    static let INSTAGRAM_SCOPE = "follower_list+public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
    static let INSTAGRAM_AUTH_STRING = "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True"
    
    case instagramURL
    
    private func getString() -> String {
        return  String(format: InstagramEnum.INSTAGRAM_AUTH_STRING, arguments: [InstagramEnum.INSTAGRAM_AUTHURL,InstagramEnum.INSTAGRAM_CLIENT_ID,InstagramEnum.INSTAGRAM_REDIRECT_URI, InstagramEnum.INSTAGRAM_SCOPE])
    }
    
    func getRequest() -> URLRequest {
        let string = getString()
        return URLRequest.init(url: URL.init(string: string)!)
    }
}

class InstagramViewController: BaseViewController, StoryboardLoadable, LoginView {
    // MARK: Properties
    
    var presenter: LoginViewPresentation?
    
    // MARK: IBOutlets
    @IBOutlet var webView: WKWebView?
    
    var loginAlert = SnapXAlert.singleInstance
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.navigationDelegate = self
        initView()
        //hideKeyboardWhenTappedAround()
    }
    
    func initView() {
        let urlRequest = InstagramEnum.instagramURL.getRequest()
        webView?.load(urlRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setupKeyboardNotifications(with: scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //removeKeyboardNotification()
    }
}

extension InstagramViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        decisionHandler(.allow)
        guard let presenter = presenter  else {
            return
        }
        let response = presenter.instagramLoginRequest(request: InstagramEnum.instagramURL.getRequest())
        if response == true {
            hideLoading()
        }
    }
    
    /* Start the network activity indicator when the web view is loading */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading()
    }
    
    /* Stop the network activity indicator when the loading finishes fail */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoading()
    }
    
    /* Stop the network activity indicator when the loading finishes */
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation){
        hideLoading()
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let user = "user"
        let password = "pass" // use dumy data to load the page
        let credential = URLCredential(user: user, password: password, persistence: URLCredential.Persistence.forSession)
        //challenge.sender?.use(credential, for: challenge)
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        removeWebView()
        webView.stopLoading()
        
    }
    
    private func  removeWebView() {
        hideLoading()
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:  { [weak self ]action in
            guard let strongSelf = self else { return }
            strongSelf.discardWebView()})
        loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.messageNoInternet, forView: self, withAction: action)
        loginAlert.show()
    }
    
    private func discardWebView() {
        presenter?.removeInstagramWebView()
    }
}

extension InstagramViewController: SnapXResult {
    
    func resultError(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.messageNoInternet,forView: self)
        loginAlert.show()
    }
    
    func resultNOInternet(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.messageNoInternet,forView: self)
        loginAlert.show()
    }
    
    func resultSuccess(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.messageSuccess,forView: self)
        loginAlert.show()
    }
    
}

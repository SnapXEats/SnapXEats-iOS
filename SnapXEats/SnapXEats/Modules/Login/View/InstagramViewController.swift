//
//  InstagramViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 05/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import WebKit


enum ServerErrorCode  {
    static let timeOut = -1001  // TIMED OUT:
    static let serverCanFound = -1003  // SERVER CANNOT BE FOUND
    static let urlNotFoundONServer = -1100  // URL NOT FOUND ON SERVER
    static let noInternetConnection = -1009  // No Internet connection
    static let loadingFiled = -999 // HTTP load failed

}

class InstagramViewController: BaseViewController, StoryboardLoadable, LoginView {
    // MARK: Properties
    
    var presenter: LoginViewPresentation?
    
    // MARK: IBOutlets
    var webView: WKWebView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var loginAlert = SnapXAlert.singleInstance
    // MARK: Lifecycle
    private var loginRequest = false
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.navigationDelegate = self
        initView()
        //hideKeyboardWhenTappedAround()
    }
    @IBAction func cancelLogin(_ sender: Any) {
        presenter?.removeInstagramWebView()
    }

    private func creatWKWebview() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .init(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 55, width: self.view.frame.width, height: self.view.frame.height), configuration: webConfiguration)
        webView.navigationDelegate = self
        let urlRequest = InstagramConstant.instagramURL.getRequest()
        webView?.load(urlRequest)
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
    }
    
    func initView() {
        creatWKWebview()
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
          //Read this link
        //http://onebigfunction.com/ios/2017/01/06/wknavigationdelegate-errors/
        guard let presenter = presenter else {
            return
        }
        loginRequest = presenter.instagramLoginRequest(request: InstagramConstant.instagramURL.getRequest())
        
        if (loginRequest == true) {
            hideLoading()
            webView.stopLoading()
            presenter.showLocationScreen()
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
        
        let nsError = error as NSError
       
        if loginRequest == false {
            removeWebView()
            webView.stopLoading()
            return
        }
        
        switch nsError.code {
        case ServerErrorCode.timeOut,
             ServerErrorCode.serverCanFound,
             ServerErrorCode.urlNotFoundONServer,
             ServerErrorCode.noInternetConnection :
            hideLoading()
            noInternet(result: .noInternet)
            
        default :
            break
        }
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
    
    func error(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.messageNoInternet,forView: self)
        loginAlert.show()
    }
    
    func noInternet(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.messageNoInternet,forView: self)
        loginAlert.show()
    }
    
    func success(result: Any?) {
        loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.messageSuccess,forView: self)
        loginAlert.show()
    }
    
    func cancel(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.cancelRequest,forView: self)
        loginAlert.show()
    }
    
}

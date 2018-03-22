//
//  InstagramLoginViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import WebKit
import SwiftInstagram


class InstagramLoginViewController: BaseViewController, StoryboardLoadable, InstagramLoginView {
    // MARK: Properties
    
    var presenter: InstagramLoginPresentation?
    
    // MARK: IBOutlets
    var webView: WKWebView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
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

extension InstagramLoginViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let urlString = navigationAction.request.url!.absoluteString
        
        guard let range = urlString.range(of: "#access_token=") else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        guard let presenter = presenter else {
            return
        }
        
        DispatchQueue.main.async {[weak self] in
            let value  = String(urlString[range.upperBound...])
            webView.stopLoading()
            let api = Instagram.shared
            if api.storeAccessToken(value) {
                presenter.getInstagramUserData {
                    self?.hideLoading()
                    webView.stopLoading()
                    self?.discardWebView()
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        
        guard let httpResponse = navigationResponse.response as? HTTPURLResponse else {
            decisionHandler(.allow)
            return
        }
        
        switch httpResponse.statusCode {
        case 400:
            decisionHandler(.cancel)
            DispatchQueue.main.async {[weak self] in
                self?.hideLoading()
                self?.noInternet(result: .noInternet)
            }
        default:
            decisionHandler(.allow)
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
        switch nsError.code {
        case ServerErrorCode.timeOut,
             ServerErrorCode.serverCanFound,
             ServerErrorCode.urlNotFoundONServer,
             ServerErrorCode.noInternetConnection :
            removeWebView()
            webView.stopLoading()
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
        loginAlert.createAlert(alertTitle: AlertTitle.loginTitle, message: AlertMessage.messageNoInternet, forView: self, withAction: action)
        loginAlert.show()
    }
    
    private func discardWebView() {
        presenter?.removeInstagramWebView()
    }
}


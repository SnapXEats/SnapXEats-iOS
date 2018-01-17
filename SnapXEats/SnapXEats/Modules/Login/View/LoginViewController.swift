//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit

enum LoginEnum{
    public static  var fbButtonTitle = "Login with FaceBook"
    public static var instagramStoryBoardID = "InstagramViewController"
}

class LoginViewController: BaseViewController, StoryboardLoadable, LoginView {
    
    // MARK: Properties
    
    var presenter: LoginViewPresentation?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var instagramLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    @IBAction func loginUsinInstagram(_ sender: Any) {
        presenter?.setView(view: self)  // keep the view as current view
        presenter?.loginUsingInstagram()
    }
    
    // Once the button is clicked, show the login dialog
    @IBAction func fbLoginClicked(_ sender: Any) {
        presenter?.setView(view: self)
        presenter?.loginUsingFaceBook()
    }
    
    var loginAlert = SnapXAlert.singleInstance
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initView()
        initView()
        //hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // setupKeyboardNotifications(with: scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) { 
        super.viewDidDisappear(animated)
        //removeKeyboardNotification()
    }
    
     func initView() {
        instagramLoginButton.addBorder(ofWidth: 1, withColor: UIColor.rgba(255.0, 255.0, 255.0, 0.34), radius: 5.0)
        facebookLoginButton.addBorder(ofWidth: 1, withColor: UIColor.rgba(255.0, 255.0, 255.0, 0.34), radius: 5.0)
    }
}


extension LoginViewController: SnapXResult {
    func resultError(result: NetworkResult) {
        loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.loginError,forView: self)
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
    
    func resultCancel(result: NetworkResult) {
        
        // loginAlert.createAlert(alertTitle: LoginAlert.loginTitle, message: LoginAlert.cancelRequest,forView: self)
        //loginAlert.show()
    }
}


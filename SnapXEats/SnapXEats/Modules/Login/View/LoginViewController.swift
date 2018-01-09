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
    
    @IBAction func loginUsinInstagram(_ sender: Any) {
        presenter?.setView(view: self)  // keep the view as current view
        presenter?.loginUsingInstagram()
    }
    
    var loginAlert = SnapXAlert.singleInstance
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    

}

extension  LoginViewController  {
    
    //TODO: Implement LoginView methods here
    
    // MARK: Private

    func initView() {
        createFaceBookLoginButton()
    }
    
    private func createFaceBookLoginButton() {
        // Add a custom facebook login button to your app
        let fbLoginButton = UIButton(type: .custom)
        fbLoginButton.backgroundColor = UIColor.darkGray
        
        fbLoginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        fbLoginButton.center = view.center;
        fbLoginButton.setTitle(LoginEnum.fbButtonTitle, for: .normal)
        
        // Handle clicks on the button
        fbLoginButton.addTarget(self,  action: #selector(self.fbLoginClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(fbLoginButton)
    }
    
    // Once the button is clicked, show the login dialog
    @objc func fbLoginClicked() {
        presenter?.setView(view: self)
        presenter?.loginUsingFaceBook()
    }
}

extension LoginViewController: SnapXResult {
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


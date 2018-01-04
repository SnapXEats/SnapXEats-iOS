//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit

class LoginViewController: BaseViewController, StoryboardLoadable {
    
    // MARK: Properties
    
    var presenter: LoginViewPresentation?
    
    // MARK: IBOutlets
    
 
    @IBOutlet var faceBookLogin: UIButton!
    
    @IBOutlet var instagramLoginButton: UIButton!
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // setupKeyboardNotifications(with: scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) { 
        super.viewDidDisappear(animated)
        removeKeyboardNotification()
    }
    
    // MARK: IBActions
    
    @IBAction func faceBookLoginClicked() {
        presenter?.loginUsingFaceBook()
    }
    
    @IBAction func instagramLoginClicked() {
        presenter?.loginUsingInstagram()
    }
    
    // MARK: Private
    
    private func setupView() {
        // TODO: Setup view here
    }
    
}

extension  LoginViewController: LoginView {
    
    //TODO: Implement MainSearchView methods here
    
}


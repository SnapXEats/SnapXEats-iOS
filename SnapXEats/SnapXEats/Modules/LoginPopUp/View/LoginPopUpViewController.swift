//
//  LoginPopUpViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 04/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class LoginPopUpViewController: BaseViewController, StoryboardLoadable {
    
    var presenter: LoginPopUpPresentation?
    var smartPhoto_Draft_Stored_id: String?
    var loadFromSmartPhot_DraftScreen = false
    var smartPhoto: SmartPhoto? {
        if let smartPhoto_Draft_Stored_id = smartPhoto_Draft_Stored_id {
            return SmartPhotoHelper.shared.getDraftPhoto(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id)
        }
        return nil
    }
    @IBOutlet var rootView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var instagramLoginButton: UIButton!
    weak var rootController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        rootView.alpha = 0.0
    }
    
    @IBAction func fbLoginAction(_ sender: Any) {
        presenter?.loginFaceBook(view: self)
    }
    
    @IBAction func instagramLoginAction(_ sender: Any) {
        if let parent = rootController {
            presenter?.loginInstagram(parentController: parent)
        }
    }
    
    @IBAction func shareLaterAction(_ sender: Any) {
        if loadFromSmartPhot_DraftScreen {
            self.dismiss(animated: true, completion: nil)
        }else if let id = smartPhoto?.restaurant_item_id {
            showShaingErrorDialog(completionHandler: {[weak self] in
                self?.presenter?.presentScreen(screen: .snapNShareHome(restaurantID: id, displayFromNotification: false))
            })
        }
    }
    
    override func success(result: Any?) {
        if let result = result as? Bool, result == true, let navigationController = rootController, let _ = smartPhoto?.restaurant_item_id {
            presenter?.presentScreen(screen: .socialLoginFromLoginPopUp(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: navigationController))
        }
    }
    
    
    func showShaingErrorDialog(completionHandler: (() -> ())?) {
        let Ok = UIAlertAction(title: SnapXButtonTitle.ok, style: UIAlertActionStyle.default, handler: { action in
            if let completionHandler = completionHandler {
                completionHandler()
            }
        })
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.draftTitle , message: AlertMessage.draftMessage, actions: [Ok], completion: nil)
    }
}

extension LoginPopUpViewController: LoginPopUpView {
    func initView() {
        
    }
    
}

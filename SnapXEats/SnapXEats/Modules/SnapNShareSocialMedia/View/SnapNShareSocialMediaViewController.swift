//
//  SnapNShareSocialMediaViewController.swift
//  SnapXEats
//
//  Created by synerzip on 16/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import FacebookShare
import SwiftInstagram

class SnapNShareSocialMediaViewController: BaseViewController, StoryboardLoadable {
    
    // MARK: Properties
    var presenter: SnapNShareSocialMediaPresentation?
    
    let loginPreferecne = LoginUserPreferences.shared
    let instagramApi = Instagram.shared
    var shareDetails: SnapNShare?
    var smartPhoto_Draft_Stored_id: String?
    
    var smartPhoto: SmartPhoto? {
        if let smartPhoto_Draft_Stored_id = smartPhoto_Draft_Stored_id, smartPhoto_Draft_Stored_id != SnapXEatsConstant.emptyString {
            return SmartPhotoHelper.shared.getDraftPhoto(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id)
        }
        return nil
    }
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var smartPhotoView: UIView!
    @IBOutlet weak var sharingMessageLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var smartPhotoImageView: UIImageView!
    
    var shareImage: UIImage? {
        guard let imagePath = smartPhoto?.dish_image_url, let imageURL  = apptoDocumentDirPath(path: imagePath) else {
            return nil
        }
        return  UIImage(contentsOfFile: imageURL.path)
    }
    
    @IBAction func fbImageShare(_ sender: Any) {
        if let _ = shareDetails {
            if loginPreferecne.fbSharingenabled {
                // if already loggedin (FB or instagram) and Fb sharing is enabled
                sharingDialogFB()
            } else {
                presenter?.loginUsingFaceBook()
            }
        }
    }
    
    @IBAction func instagramImageShare(_ sender: Any) {
        if let _ = shareDetails {
            sharingDialogInstagram()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shareDetails == nil {
            if let restaurantID = smartPhoto?.restaurant_item_id, let smartPhoto_Draft_Stored_id = smartPhoto_Draft_Stored_id {
                showLoading()
                presenter?.sendPhotoReview(restaurantID: restaurantID, smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id)
            }
        }
    }
    
    override func success(result: Any?) {
        if let _ = result as? Bool {
            sharingDialogFB()
        } else if let result = result as? SnapNShare {
            shareDetails = result
            showSharingDetails()
        }
    }
    
    override func noInternet(result: NetworkResult) {
        showShaingErrorDialog(message: AlertMessage.messageNoInternet, completionHandler: {
            if let parent = self.navigationController, self.shareDetails == nil {
                parent.popViewController(animated: true)
            }
        })
    }
    
    func sharingDialogFB() {
        guard let shareDetails = self.shareDetails, let shareURL = URL(string: shareDetails.dish_image_url ?? "") else {
            return
        }
        
        let content = LinkShareContent(url: shareURL, quote: shareDetails.message)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .automatic
        shareDialog.presentingViewController = self
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { [weak self] result in
            switch result {
            case .failed(_):
                self?.showShaingErrorDialog(message: AlertMessage.sharingFailed, completionHandler: nil)
            case .cancelled:
                self?.showShaingErrorDialog(message: AlertMessage.sharingCanceled, completionHandler: nil)
            case .success:
                if let smartPhoto_Draft_Stored_id = self?.smartPhoto_Draft_Stored_id, let restaurantID = self?.smartPhoto?.restaurant_item_id {
                    SmartPhotoHelper.shared.deleteDraftReview(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id)
                    deleteUserReviewData(restaurantId: restaurantID)
                    self?.presenter?.presentScreen(screen: .sharedSuccess(restaurantID: restaurantID))
                }
                
            }
        }
        try! shareDialog.show()
    }
    
    func sharingDialogInstagram() {
        if let image = shareImage {
            InstagramManager.shared.shareONInstagram(image: image, description: shareDetails?.message ?? "", viewController: self)
        }
    }
    
    func showSharingDetails() {
        if let shareDetails = shareDetails {
            sharingMessageLabel.text = shareDetails.message ?? ""
            restaurantNameLabel.text = shareDetails.restaurant_name ?? ""
            if let image = shareImage {
                smartPhotoImageView.image = image
            }
        }
    }
    
    func showShaingErrorDialog(message: String, completionHandler: (() -> ())?) {
        let Ok = UIAlertAction(title: SnapXButtonTitle.ok, style: UIAlertActionStyle.default, handler: { action in
            if let completionHandler = completionHandler {
                completionHandler()
            }
        })
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.sharingTitle , message: message, actions: [Ok], completion: nil)
    }
    
}

extension SnapNShareSocialMediaViewController: SnapNShareSocialMediaView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: true)
        smartPhotoView.addShadow(width: 0.0, height: 0.0)
    }
}





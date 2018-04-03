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
    let dishReview = LoginUserPreferences.shared.userDishReview
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var smartPhotoView: UIView!
    @IBOutlet weak var sharingMessageLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var smartPhotoImageView: UIImageView!
    
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
            showLoading()
            presenter?.sendPhotoReview()
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
                self?.showShaingFailedDialog()
            case .cancelled:
                self?.showShaingCancelDialog()
            case .success:
                if let restaurantId = self?.dishReview.restaurantInfoId {
                    deleteUserReviewData(restaurantId: restaurantId)
                    self?.presenter?.presentScreen(screen: .sharedSuccess(restaurantID: restaurantId))
                }
                
            }
        }
        try! shareDialog.show()
    }
    
    func sharingDialogInstagram() {
        if let restaurantId = dishReview.restaurantInfoId, let imagePath = getPathForSmartPhotoForRestaurant(restaurantId: restaurantId) {
            // For instagram you need to send the image. we can't send the url path for instagram.
            if let image = UIImage(contentsOfFile: imagePath.path) {
                InstagramManager.shared.shareONInstagram(image: image, description: shareDetails?.message ?? "", viewController: self)
            }
        }
    }
    
    func showSharingDetails() {
        if let shareDetails = shareDetails {
            sharingMessageLabel.text = shareDetails.message ?? ""
            restaurantNameLabel.text = shareDetails.restaurant_name ?? ""
            if let restaurantId = dishReview.restaurantInfoId, let imagePath = getPathForSmartPhotoForRestaurant(restaurantId: restaurantId),
                let image = UIImage(contentsOfFile: imagePath.path) {
                smartPhotoImageView.image = image
            }
        }
    }
    
    func showShaingFailedDialog() {
        let Ok = UIAlertAction(title: SnapXButtonTitle.ok, style: UIAlertActionStyle.default, handler: nil)
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.sharingTitle , message: AlertMessage.sharingFailed, actions: [Ok], completion: nil)
    }
    
    func showShaingCancelDialog() {
        let Ok = UIAlertAction(title: SnapXButtonTitle.ok, style: UIAlertActionStyle.default, handler: nil)
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.sharingTitle , message: AlertMessage.sharingCanceled, actions: [Ok], completion: nil)
    }
}

extension SnapNShareSocialMediaViewController: SnapNShareSocialMediaView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: true)
        smartPhotoView.addShadow(width: 0.0, height: 0.0)
    }
}





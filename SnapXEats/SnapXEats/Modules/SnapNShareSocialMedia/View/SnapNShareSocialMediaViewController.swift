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
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var smartPhotoView: UIView!
    @IBOutlet weak var sharingMessageLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var smartPhotoImageView: UIImageView!
    
    @IBAction func fbImageShare(_ sender: Any) {
        if loginPreferecne.fbSharingenabled {
            // if already loggedin (FB or instagram) and Fb sharing is enabled
            sharingDialogFB()
        } else {
             presenter?.loginUsingFaceBook()
        }
    }
    
    @IBAction func instagramImageShare(_ sender: Any) {
        sharingDialogInstagram()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        showLoading()
        presenter?.sendPhotoReview()
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
        
        let content = LinkShareContent(url: shareURL)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .automatic
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            switch result {
            case .failed(let value ):
                print("falied \(value.localizedDescription)")
            case .cancelled:
                print("canecel")
            case .success:
                print("Success")  // You need to add the success pop here
            }
        }
        try! shareDialog.show()
    }
    
    func sharingDialogInstagram() {
        // For instagram you need to send the image. we can't send the url path for instagram.
        if let image = UIImage(named: SnapXEatsImageNames.placeholder_cuisine) { 
            InstagramManager.shared.shareONInstagram(image: image, description: "This is the image on Instagram", viewController: self)
        }
    }
    
    func showSharingDetails() {
        if let shareDetails = self.shareDetails {
            sharingMessageLabel.text = shareDetails.message ?? ""
            restaurantNameLabel.text = shareDetails.restaurant_name ?? ""
            if let url = URL(string: shareDetails.dish_image_url ?? "") {
                smartPhotoImageView.af_setImage(withURL: url, placeholderImage:UIImage(named: SnapXEatsImageNames.foodcard_placeholder)!)
            }
        }
    }
}

extension SnapNShareSocialMediaViewController: SnapNShareSocialMediaView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: true)
        smartPhotoView.addShadow()
    }
}

    



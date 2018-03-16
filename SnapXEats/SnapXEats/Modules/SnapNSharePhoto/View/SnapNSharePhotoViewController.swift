//
//  SnapNSharePhotoViewController.swift
//  SnapXEats
//
//  Created by synerzip on 15/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStarRatingView

class SnapNSharePhotoViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties
    var presenter: SnapNSharePhotoPresentation?
    var snapPhoto: UIImage!
    
    @IBOutlet var snapPhotoImageView: UIImageView!
    @IBOutlet var starRatingView: SwiftyStarRatingView!
    @IBOutlet var reviewTextView: UITextView!

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func addShareButtonOnNavigationItem() {
        let shareButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        shareButton.setImage(UIImage(named: SnapXEatsImageNames.share), for: UIControlState.normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
    }
    
    @objc func shareButtonAction() {
        showConfirmationForShare()
    }
    
    func showConfirmationForShare() {
        let confirmationAlert = UIAlertController(title: "", message: "Do you want to Add and Share your Review?", preferredStyle: .alert)
        let discardAction = UIAlertAction(title: "Discard", style: .default) { (action) in
            print("Discarded")
        }
        let continueAction = UIAlertAction(title: "Continue", style: .default) { [weak self] (action) in
            self?.gotoSnapNShareSocialMediaView()
        }
        confirmationAlert.addAction(discardAction)
        confirmationAlert.addAction(continueAction)
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    func gotoSnapNShareSocialMediaView() {
        if let parentNVController = self.navigationController {
            presenter?.gotoSnapNSharesocialMediaView(parent: parentNVController)
        }
    }
}

extension SnapNSharePhotoViewController: SnapNSharePhotoView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: true)
        addShareButtonOnNavigationItem()
        snapPhotoImageView.image = snapPhoto
        starRatingView.addTarget(self, action: #selector(ratingsChanged), for: .valueChanged)
        reviewTextView.text = "Write what you feel about dish"
        reviewTextView.textColor = UIColor.lightGray
    }
    
    @objc func ratingsChanged() {
    }
}

extension SnapNSharePhotoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = SnapXEatsAppDefaults.emptyString
            textView.textColor = UIColor.black
        }
    }
}



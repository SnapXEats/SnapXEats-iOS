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

    let reviewPlaceholderText = "Write what you feel about dish"
    
    // MARK: Properties
    var presenter: SnapNSharePhotoPresentation?
    var snapPhoto: UIImage!
    var audioReviewDuration: Int = 0
    var rating: Int {
        return Int(starRatingView.value)
    }
    
    @IBOutlet var snapPhotoImageView: UIImageView!
    @IBOutlet var starRatingView: SwiftyStarRatingView!
    @IBOutlet var reviewTextView: UITextView!
    @IBOutlet var recordAudioReviewButton: UIButton!
    @IBOutlet var playRecordingButton: UIButton!
    
    @IBAction func addaudioReviewButtonAction(_ sender: UIButton) {
        showAudioRecordingPopUpViewWithType(type: .record)
    }
    
    @IBAction func playAudioReviewButtonAction(_ sender: UIButton) {
        showAudioRecordingPopUpViewWithType(type: .play)
    }
    
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
        let confirmationAlert = UIAlertController(title: SnapXEatsAppDefaults.emptyString, message:AlertMessage.shareConfirmation , preferredStyle: .alert)
        let discardAction = UIAlertAction(title: SnapXButtonTitle.discard, style: .default) { (action) in
            // Action for Discard
        }
        let continueAction = UIAlertAction(title: SnapXButtonTitle.continueNext, style: .default) { [weak self] (action) in
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
    
    private func showAudioRecordingPopUpViewWithType(type: AudioRecordingPopupTypes) {
        let audioRecordPopupView = UINib(nibName:SnapXEatsNibNames.audioRecordingPopup, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AudioRecordingPopUp
        audioRecordPopupView.audioRecordingPopupDelegate = self
        let audioPopupFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        audioRecordPopupView.setupPopup(audioPopupFrame, type: type, forDuration: audioReviewDuration, forViewController: self)
        self.view.addSubview(audioRecordPopupView)
    }
    
    private func updateUIForAudioReview(audioReviewAvailable: Bool) {
        audioReviewAvailable ? recordAudioReviewButton.isInactive() : recordAudioReviewButton.isActive()
        audioReviewAvailable ? playRecordingButton.isActive() : playRecordingButton.isInactive()
        playRecordingButton.setTitle(timeString(time: TimeInterval(audioReviewDuration)), for: .normal)
    }
}

extension SnapNSharePhotoViewController: SnapNSharePhotoView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: true)
        addShareButtonOnNavigationItem()
        snapPhotoImageView.image = snapPhoto
        reviewTextView.text = reviewPlaceholderText
        reviewTextView.textColor = UIColor.lightGray
        
        playRecordingButton.isInactive()
        recordAudioReviewButton.isActive()
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

extension SnapNSharePhotoViewController: AudioRecordingPopUpViewActionsDelegate {
    func audioRecordingDone(_ popupView: AudioRecordingPopUp, forDuration duration: Int) {
        popupView.removeFromSuperview()
        audioReviewDuration = duration
        updateUIForAudioReview(audioReviewAvailable: true)
    }
    
    func audioPlaybackDone(_ popupView: AudioRecordingPopUp) {
        popupView.removeFromSuperview()
    }
    
    func audioRecordingDeleted(_ popupView: AudioRecordingPopUp) {
        popupView.removeFromSuperview()
        updateUIForAudioReview(audioReviewAvailable: false)
        audioReviewDuration = 0
    }
}



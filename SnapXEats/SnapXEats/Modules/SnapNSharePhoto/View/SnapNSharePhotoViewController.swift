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
    var loginPreference  = LoginUserPreferences.shared
    var restaurntID: String?
    var rating: Int {
        return Int(starRatingView.value)
    }
    
    let loginPreferecne = LoginUserPreferences.shared
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
        let shareButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 18))
        shareButton.setImage(UIImage(named: SnapXEatsImageNames.share), for: UIControlState.normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
    }
    
    @objc func shareButtonAction() {
        if let Id = restaurntID {
         isSharingInformationComplete()
            ? loginPreferecne.isLoggedIn ? continueSharingUserReview() : presenter?.presentScreenLoginPopup(screen: .loginPopUp(restaurantID: Id)) : showIncompleteInformationAlert()
        }
    }
    
    private func isSharingInformationComplete() -> Bool {
        return rating > 0 ? true : false
    }
    
    func showIncompleteInformationAlert() {
        let incompleteInfoAlert = UIAlertController(title: SnapXEatsAppDefaults.emptyString, message:AlertMessage.incompleteShareInformation , preferredStyle: .alert)
        let okAction = UIAlertAction(title: SnapXButtonTitle.ok, style: .cancel, handler: nil)
        incompleteInfoAlert.addAction(okAction)
        present(incompleteInfoAlert, animated: true, completion: nil)
    }
    
    func continueSharingUserReview() {
        setReviewData()
        gotoSnapNShareSocialMediaView()
    }
    
    func setReviewData() {
        if let restaurntID = restaurntID {
         loginPreference.userDishReview.rating = rating
            loginPreference.userDishReview.reviewText = (reviewTextView.text == reviewPlaceholderText) ? SnapXEatsAppDefaults.emptyString : reviewTextView.text
         loginPreference.userDishReview.reviewAudio =  getPathForAudioReviewForRestaurant(restaurantId: restaurntID)
         loginPreference.userDishReview.dishPicture = getPathForSmartPhotoForRestaurant(restaurantId: restaurntID)
         //loginPreference.userDishReview.restaurantInfoId  // This will get set in SnapNShareHomeViewController
        }
    }
    
    func gotoSnapNShareSocialMediaView() {
        if let parentNVController = self.navigationController {
            presenter?.gotoSnapNSharesocialMediaView(parent: parentNVController)
        }
    }
    
    private func showAudioRecordingPopUpViewWithType(type: AudioRecordingPopupTypes) {
        dismissKeyboard()
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
    func audioRecordingCancelled(_ popupView: AudioRecordingPopUp) {
        popupView.removeFromSuperview()
    }
    
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



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
    let ReviewTextCharacterLimit = 140
    
    // MARK: Properties
    var presenter: SnapNSharePhotoPresentation?
    var snapPhoto: UIImage!
    var audioReviewDuration: Int = 0
    var loginPreference  = LoginUserPreferences.shared
    var restaurantDetails: RestaurantDetails?
    var rating: Int {
        return Int(starRatingView.value)
    }
    var smartPhoto: SmartPhoto?
    let loginPreferecne = LoginUserPreferences.shared
    @IBOutlet var snapPhotoImageView: UIImageView!
    @IBOutlet var starRatingView: SwiftyStarRatingView!
    @IBOutlet var reviewTextView: UITextView!
    @IBOutlet var recordAudioReviewButton: UIButton!
    @IBOutlet var playRecordingButton: UIButton!
    var isDirty: Bool {
        return  isSharingInformationComplete() || isPhotoFileExist() || isAudioFileExist()
    }
    
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
    
    func saveFileInDraft() -> SmartPhoto? {
        if let restaurantDetails = restaurantDetails, let id = restaurantDetails.id, let imageURL = SmartPhotoPath.draft(fileName: fileManagerConstants.smartPhotoFileName, id: id).getPath(), FileManager.default.fileExists(atPath: imageURL.path) {
            let smartPhoto = SmartPhoto()
            smartPhoto.restaurant_item_id = id
            smartPhoto.smartPhoto_Draft_Stored_id = getTimeInterval()
            if let url = SmartPhotoPath.draft(fileName: fileManagerConstants.audioReviewFileName, id: id).getPath(),
                FileManager.default.fileExists(atPath: url.path) {
                smartPhoto.audio_review_url =  getPathTillDocDir(path: url.path) ?? ""
            }
            
            smartPhoto.dish_image_url =  getPathTillDocDir(path: imageURL.path) ?? ""
            smartPhoto.text_review = (reviewTextView.text == reviewPlaceholderText) ? SnapXEatsAppDefaults.emptyString : reviewTextView.text
            smartPhoto.restaurant_aminities = restaurantDetails.restaurant_amenities
            smartPhoto.restaurant_name = restaurantDetails.name ?? ""
            smartPhoto.rating = rating
            SmartPhotoHelper.shared.savePhotoDraft(smartPhoto: smartPhoto)
            return smartPhoto
        }
        return nil
    }
    
    private func addShareButtonOnNavigationItem() {
        let shareButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 38, height: 18))
        shareButton.setImage(UIImage(named: SnapXEatsImageNames.share), for: UIControlState.normal)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareButton)
    }
    
    @objc func shareButtonAction() {
        if let _ = restaurantDetails?.id, let parent = self.navigationController {
            if  isSharingInformationComplete() {
                hideKeyboardWhenTappedAround()
                if loginPreferecne.isLoggedIn {
                    continueSharingUserReview()
                } else {
                    setReviewData()
                    if let storedID =  smartPhoto?.smartPhoto_Draft_Stored_id {
                        presenter?.presentScreenLoginPopup(screen: .loginPopUp(storedID: storedID, parentController: parent, loadFromSmartPhot_Draft: false))
                    }
                }
            } else {
                showIncompleteInformationAlert()
            }
        }
    }
    
    private func isSharingInformationComplete() -> Bool {
        return rating > 0 ? true : false
    }
    
    private func isPhotoFileExist() -> Bool {
        if let id = restaurantDetails?.id, let imageURL = SmartPhotoPath.draft(fileName: fileManagerConstants.smartPhotoFileName, id: id).getPath(), FileManager.default.fileExists(atPath: imageURL.path) {
            return true
        }
        return false
    }
    
    private func isAudioFileExist() -> Bool {
        if let id = restaurantDetails?.id, let audioURL = SmartPhotoPath.draft(fileName: fileManagerConstants.audioReviewFileName, id: id).getPath(), FileManager.default.fileExists(atPath: audioURL.path) {
            return true
        }
        return false
    }
    
    func showIncompleteInformationAlert() {
        let incompleteInfoAlert = UIAlertController(title: SnapXEatsAppDefaults.emptyString, message:AlertMessage.incompleteShareInformation , preferredStyle: .alert)
        let okAction = UIAlertAction(title: SnapXButtonTitle.ok, style: .cancel, handler: nil)
        incompleteInfoAlert.addAction(okAction)
        present(incompleteInfoAlert, animated: true, completion: nil)
    }
    
    func continueSharingUserReview() {
        if checkRechability() {
            showShareDiscardDialog()
        }
    }
    
    
    func showShareDiscardDialog() {
            let cancel = UIAlertAction(title: SnapXButtonTitle.cancel, style: .default, handler: nil)
        let continueTitle = UIAlertAction(title: SnapXButtonTitle.continueNext, style: .default, handler: { [weak self] action in
            self?.setReviewData()
            self?.gotoSnapNShareSocialMediaView()
        })
            UIAlertController.presentAlertInViewController(self, title: AlertTitle.snapNShare, message: AlertMessage.shareReviewMessage, actions: [cancel, continueTitle], completion: nil)

    }
    
    private func enableBackButtonAction() {
        let newBackButton = UIBarButtonItem(image: UIImage(named: SnapXEatsImageNames.backArrow), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    // Then handle the button selection
    @objc func backAction() {
        if  isDirty { showErrorDialog() }
        else { self.navigationController?.popViewController(animated: true) }
    }
    
    func showErrorDialog() {
        let Ok = UIAlertAction(title: SnapXButtonTitle.ok, style: UIAlertActionStyle.default, handler: { [weak self] action in
            if let id = self?.restaurantDetails?.id {
                deleteUserReviewData(restaurantId: id)
            }
            self?.navigationController?.popViewController(animated: true)
        })
        let cancel = UIAlertAction(title: SnapXButtonTitle.cancel, style: UIAlertActionStyle.default, handler: nil)
        UIAlertController.presentAlertInViewController(self, title: nil , message: AlertMessage.reviewMessage, actions: [cancel,Ok], completion: nil)
    }
    
    
    func setReviewData() {
        if let _ = restaurantDetails?.id {
            smartPhoto =  saveFileInDraft()
        }
    }
    
    func gotoSnapNShareSocialMediaView() {
        if let parentNVController = self.navigationController, let _ = restaurantDetails?.id, let timeInterval = smartPhoto?.smartPhoto_Draft_Stored_id {
            presenter?.gotoSnapNSharesocialMediaView(timeInterval: timeInterval, parent: parentNVController)
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
        enableBackButtonAction()
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        return changedText.count <= ReviewTextCharacterLimit
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



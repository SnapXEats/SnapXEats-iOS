//
//  smartPhotoViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

enum SmartPhotoType {
    case draftPhoto, smartPhoto, downlaodedSmartPhoto
}

class SmartPhotoViewController: BaseViewController, StoryboardLoadable {
    
    // MARK: Properties
    
    var presenter: SmartPhotoPresentation?
    
    @IBOutlet weak var draftShareButton: UIButton!
    @IBOutlet weak var smartPhotoImage: UIImageView!
    // MARK: Lifecycle
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var buttonView: UIView!
    var smartPhoto: SmartPhoto?
    var dishID: String?
    var smartPhoto_Draft_Stored_id: String?
    
    var photoType = SmartPhotoType.smartPhoto
    var alreadyDownloaded = false
    weak var parentController: UINavigationController?
    let isloggedIn = LoginUserPreferences.shared.isLoggedIn
    
    @IBAction func draftShareAction(_ sender: Any) {
        presenter?.stopAudio()
        if let smartPhoto_Draft_Stored_id = smartPhoto_Draft_Stored_id,  smartPhoto_Draft_Stored_id != SnapXEatsConstant.emptyString, let parent = parentController {
            if isloggedIn == false {
                self.dismiss(animated: true, completion: { [weak self] in
                     self?.presenter?.presentScreen(screen: .loginPopUp(storedID: smartPhoto_Draft_Stored_id, parentController: parent, loadFromSmartPhot_Draft: true))
                })
               
            } else {
                presenter?.presentScreen(screen: .snapAndShareFromDraft(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: parent))
            }
        }
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        if infoButton.isSelected {
            removeSubView()
        } else {
            if let photoInfo = smartPhoto {
                presenter?.stopAudio()
                presenter?.presentView(view: .info(photoInfo: photoInfo))
            }
        }
        updateTintColor(sender: sender)
    }
    
    func removeSubView() {
        for subView in containerView.subviews {
            subView.removeFromSuperview()
        }
        containerView.isHidden = true
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
        if messageButton.isSelected {
            removeSubView()
        } else {
            presenter?.stopAudio()
            presenter?.presentView(view: .textReview(textReview: smartPhoto?.text_review ?? ""))
        }
        updateTintColor(sender: sender)
    }
    @IBAction func audioButtonAction(_ sender: Any) {
        if audioButton.isSelected {
            presenter?.stopAudio()
            removeSubView()
        } else if let smartPhoto = smartPhoto {
            switch photoType {
            case .smartPhoto:
                presenter?.presentView(view: .audio(audioURL: smartPhoto.audio_review_url))
            case .draftPhoto, .downlaodedSmartPhoto:
                if let audioUrl = apptoDocumentDirPath(path: smartPhoto.audio_review_url),
                    FileManager.default.fileExists(atPath: audioUrl.path) {
                    presenter?.presentView(view: .audio(audioURL: audioUrl.absoluteString))
                }
            }
            
        }
        updateTintColor(sender: sender)
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        if downloadButton.isSelected {
            presenter?.stopAudio()
            removeSubView()
            updateTintColor(sender: sender)
        } else if let _ = smartPhoto?.dish_image_url, checkRechability() {
            presenter?.presentView(view: .download(smartPhoto: smartPhoto))
            updateTintColor(sender: sender)  // if internet is off tint colour should not change
        }
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        presenter?.stopAudio()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func updateTintColor(sender: Any?) {
        if let button = sender as? UIButton {
            switch button.tag  {
            case 1001:
                infoButton.isSelected = infoButton.isSelected ? false : true
                messageButton.isSelected = false
                audioButton.isSelected = false
                downloadButton.isSelected = false
            case 1002:
                infoButton.isSelected = false
                messageButton.isSelected = messageButton.isSelected ? false : true
                audioButton.isSelected = false
                downloadButton.isSelected = false
            case 1003:
                infoButton.isSelected = false
                messageButton.isSelected = false
                audioButton.isSelected = audioButton.isSelected ? false : true
                downloadButton.isSelected = false
            case 1004:
                infoButton.isSelected = false
                messageButton.isSelected = false
                audioButton.isSelected = false
                downloadButton.isSelected = downloadButton.isSelected ? false : true
            default: break
                
            }
        } else {
            infoButton.isSelected = false
            messageButton.isSelected = false
            audioButton.isSelected = false
            downloadButton.isSelected = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showView()
    }
    
    override func success(result: Any?) {
        if let smartPhoto = result as? SmartPhoto {
            self.smartPhoto = smartPhoto
            if let id = smartPhoto.restaurant_item_id {
                alreadyDownloaded = presenter?.checkSmartPhoto(smartPhotoID: id) ?? false
            }
            loadSmartPhoto()
        }
    }
    
    func showView() {
        switch photoType {
        case .smartPhoto:
            loadPhoto()
        case .draftPhoto:
            loadDraftView()
        case .downlaodedSmartPhoto:
            loadDownloadedSmartPhotoView()
        }
    }
    
    func loadDraftView() {
        draftShareButton.isHidden = false
        smartPhoto = SmartPhotoHelper.shared.getDraftPhoto(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id ?? SnapXEatsConstant.emptyString)
        if let photos = smartPhoto {
            if photos.dish_image_url != SnapXEatsConstant.emptyString, let imageUrl = apptoDocumentDirPath(path: photos.dish_image_url) {
                if FileManager.default.fileExists(atPath: imageUrl.path), let imageItem = UIImage(contentsOfFile: imageUrl.path)  {
                    smartPhotoImage.image = imageItem
                }
            }
            
            if photos.audio_review_url != SnapXEatsConstant.emptyString, let audioUrl = apptoDocumentDirPath(path: photos.audio_review_url)  {
                if FileManager.default.fileExists(atPath: audioUrl.path) {
                    audioButton.isHidden = false
                }
            }
            
            if photos.text_review != "" {
                messageButton.isHidden = false
            }
        }
    }
    
    func loadSmartPhoto() {
        downloadButton.isHidden = alreadyDownloaded
        if let url = smartPhoto?.dish_image_url, let imageURL = URL(string: url) {
            smartPhotoImage.af_setImage(withURL: imageURL, placeholderImage:UIImage(named: SnapXEatsImageNames.restaurant_speciality_placeholder)!)
        }
        
        if let audio = smartPhoto?.audio_review_url, audio != ""  {
            audioButton.isHidden = false
        }
        
        if let text = smartPhoto?.text_review , text != "" {
            messageButton.isHidden = false
        }
    }
    
    func loadDownloadedSmartPhotoView() {
        smartPhoto = SmartPhotoHelper.shared.getSmartPhoto(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id ?? SnapXEatsConstant.emptyString)
        if let photos = smartPhoto {
            if photos.dish_image_url != SnapXEatsConstant.emptyString, let imageUrl = apptoDocumentDirPath(path: photos.dish_image_url) {
                if FileManager.default.fileExists(atPath: imageUrl.path), let imageItem = UIImage(contentsOfFile: imageUrl.path)  {
                    smartPhotoImage.image = imageItem
                }
            }
            
            if photos.audio_review_url != SnapXEatsConstant.emptyString, let audioUrl = apptoDocumentDirPath(path: photos.audio_review_url) {
                if FileManager.default.fileExists(atPath: audioUrl.path) {
                    audioButton.isHidden = false
                }
            }
            
            if photos.text_review != "" {
                messageButton.isHidden = false
            }
        }
    }
    
    @objc func hideButtonView() {
        buttonView.isHidden = buttonView.isHidden ? false : true
        if buttonView.isHidden {
            presenter?.stopAudio()
            removeSubView()
        }
        updateTintColor(sender: nil) // this is to reset all the button
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unRegisterNotification()
    }
    
    override func internetConnected() {
        showView()
    }
    
    func loadPhoto() {
        downloadButton.isHidden = false
        if let id = dishID, smartPhoto == nil, checkRechability() {
            showLoading()
            presenter?.getSmartPhotoDetails(dishID: id)
        } else if smartPhoto != nil  {
            loadSmartPhoto()
        }
    }
}

extension SmartPhotoViewController: SmartPhotoView {
    func initView() {
        registerNotification()
        smartPhotoImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideButtonView))
        tapGestureRecognizer.numberOfTapsRequired = 1
        smartPhotoImage.addGestureRecognizer(tapGestureRecognizer)
        rootView.layer.cornerRadius = PopupConstants.containerViewRadius
        rootView.addShadow()
        containerView.isHidden = true
        buttonView.isHidden = true
        audioButton.isHidden = true
        messageButton.isHidden = true
        draftShareButton.isHidden = true
        downloadButton.isHidden = true
    }
    
}

//
//  smartPhotoViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SmartPhotoViewController: BaseViewController, StoryboardLoadable {
    
    // MARK: Properties
    
    var presenter: SmartPhotoPresentation?
    
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
    
    @IBAction func infoButtonAction(_ sender: Any) {
        
        if infoButton.isSelected {
            removeSubView()
        } else {
            if let photoInfo = smartPhoto {
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
            presenter?.presentView(view: .textReview(textReview: smartPhoto?.text_review ?? ""))
        }
        updateTintColor(sender: sender)
    }
    @IBAction func audioButtonAction(_ sender: Any) {
        if audioButton.isSelected {
            removeSubView()
        } else if let audioURL = smartPhoto?.audio_review_url {
                presenter?.presentView(view: .audio(audioURL: audioURL))
        
        }
        updateTintColor(sender: sender)
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        if downloadButton.isSelected {
            removeSubView()
        } else if let imageURL = smartPhoto?.dish_image_url {
            presenter?.presentView(view: .download(imageURL: imageURL, audioURL: smartPhoto?.audio_review_url))
        }
        updateTintColor(sender: sender)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
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
        if let id = dishID, smartPhoto == nil {
            showLoading()
            presenter?.getSmartPhotoDetails(dishID: id)
        }
    }
    
    override func success(result: Any?) {
        if let smartPhoto = result as? SmartPhoto {
            self.smartPhoto = smartPhoto
            loadSmartPhoto()
        }
    }
    
    func loadSmartPhoto() {
        if let url = smartPhoto?.dish_image_url, let imageURL = URL(string: url) {
            smartPhotoImage.af_setImage(withURL: imageURL, placeholderImage:UIImage(named: SnapXEatsImageNames.restaurant_speciality_placeholder)!)
        }
        
        if let _ = smartPhoto?.audio_review_url {
            audioButton.isHidden = false
        }
        
        if let text = smartPhoto?.text_review , text != "" {
            messageButton.isHidden = false
        }
    }
    
    @objc func hideButtonView() {
        buttonView.isHidden = buttonView.isHidden ? false : true
        if buttonView.isHidden {
             removeSubView()
        }
        updateTintColor(sender: nil) // this is to reset all the button
    }
}

extension SmartPhotoViewController: SmartPhotoView {
    func initView() {
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
    }
    
}

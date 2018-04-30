//
//  RestaurantDetailsActionButtonView.swift
//  SnapXEats
//
//  Created by Priyanka Gaikwad on 24/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

protocol RestaurantDetailsActionButtonViewDelegate: class {
    func reviewMessageAction()
    func playAudioAction()
    func downloadAction()
}

class RestaurantDetailsActionButtonView: UIView {

    @IBOutlet weak var audioReviewButton: UIButton!
    @IBOutlet weak var textReviewButton: UIButton!
    @IBOutlet weak var audioTextReviewButtonSpacing: NSLayoutConstraint!
    @IBOutlet weak var downloadButton: UIButton!
    
    // MARK:Properties
    var delegate: RestaurantDetailsActionButtonViewDelegate?
    
    // MARK:Constant
    let defaultAudioTextReviewButtonSpacing:CGFloat = 10
    let estimatedAudioTextReviewButtonSpacing:CGFloat = 52
    
    func setupView(_ frame: CGRect, alreadyDownloaded: Bool) {
        downloadButton.isHidden = alreadyDownloaded
        self.isUserInteractionEnabled = true
        self.frame = frame
        self.backgroundColor = UIColor.clear
    }

    func toggleAudioReviewButtonState(shouldHide: Bool) {
        audioReviewButton.isHidden = shouldHide
        layoutIfNeeded()
    }
    
    func toggleTextReviewButtonState(shouldHide: Bool) {
        textReviewButton.isHidden = shouldHide
        audioTextReviewButtonSpacing.constant = shouldHide ? defaultAudioTextReviewButtonSpacing : estimatedAudioTextReviewButtonSpacing
        layoutIfNeeded()
    }
    
    func toggleDownloadButtonState(shouldHide: Bool) {
        downloadButton.isHidden = shouldHide
        layoutIfNeeded()
    }
    
    @IBAction func reviewMessageAction(_ sender: Any) {
        delegate?.reviewMessageAction()
    }
    
    @IBAction func playAudioAction(_ sender: Any) {
        delegate?.playAudioAction()
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        delegate?.downloadAction()
    }
    
    
}

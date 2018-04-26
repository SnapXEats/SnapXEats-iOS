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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var audioReviewButton: UIButton!
    @IBOutlet weak var textReviewButton: UIButton!
    @IBOutlet weak var audioTextReviewButtonSpacing: NSLayoutConstraint!
    
    var delegate: RestaurantDetailsActionButtonViewDelegate?
    
//    52/0
    
    func setupView(_ frame: CGRect) {
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
        audioTextReviewButtonSpacing.constant = shouldHide ? 10 : 52
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

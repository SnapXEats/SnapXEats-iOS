//
//  TextReviewPopUp.swift
//  SnapXEats
//
//  Created by Priyanka Gaikwad on 25/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class TextReviewPopUp: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet var textReviewOkayButton: UIButton!
    
    @IBOutlet weak var textReview: UITextView!
    
    var parentController: UIViewController!

    func setupPopup(_ frame: CGRect, text: String, forViewController vc: UIViewController) {
        self.frame = frame
        self.parentController = vc
        containerView.layer.cornerRadius = popupConstants.containerViewRadius
        containerView.addShadow()
        textReviewOkayButton.layer.cornerRadius = textReviewOkayButton.frame.height/2
        textReview.isEditable = false
        textReview.text = text
    }
    
    @IBAction func okayAction(_ sender: Any) {
        self.removeFromSuperview()
    }
}

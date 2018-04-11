//
//  AudioRecordingPopUp.swift
//  SnapXEats
//
//  Created by synerzip on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import AVFoundation


class SmartPhotoAudio: UIView {
    var textReview = ""
    
    @IBOutlet weak var reviewMessageLabel: UILabel!
    
    func initView() {
        reviewMessageLabel.text = textReview
    }
}



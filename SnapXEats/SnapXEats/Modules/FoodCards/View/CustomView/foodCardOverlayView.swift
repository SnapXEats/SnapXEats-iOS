//
//  foodCardOverlayView.swift
//  SnapXEats
//
//  Created by synerzip on 23/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import Koloda

class foodCardOverlayView: OverlayView {
    
    @IBOutlet var overlayImageView: UIImageView!
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: SnapXEatsImageNames.notnowOverlay)
            case .right? :
                overlayImageView.image = UIImage(named: SnapXEatsImageNames.likeitOverlay)
            case .up? :
                overlayImageView.image = UIImage(named: SnapXEatsImageNames.trylaterOverlay)
            default:
                overlayImageView.image = nil
            }
        }
    }
}

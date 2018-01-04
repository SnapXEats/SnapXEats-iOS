//
//  PlainButtonCell.swift
//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit


class PlainButtonCell: UITableViewCell, NibLoadableView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    
    var delegate: PlainButtonCellDelegate?
    
    func setup(delegate: PlainButtonCellDelegate?) {
        self.delegate = delegate
        setupButton()
        setupSeparator()
    }
    
    @IBAction func onButtonClicked(_ sender: UIButton) {
        delegate?.onButtonClicked(self)
    }
    
    private func setupButton() {

    }
    
    private func setupSeparator() {

    }
}

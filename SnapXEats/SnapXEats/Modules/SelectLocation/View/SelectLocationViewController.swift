//
//  SelectLocationViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SelectLocationViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    
    var presenter: SelectLocationPresentation?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func closeSelectLocation(_ sender: Any) {
        presenter?.dismissScreen()
    }
}

extension SelectLocationViewController: SelectLocationView {
    func initView() {
        
    }
    
    // TODO: implement view output methods
}

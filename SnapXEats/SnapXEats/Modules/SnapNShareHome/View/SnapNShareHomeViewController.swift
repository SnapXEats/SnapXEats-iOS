//
//  SnapNShareHomeViewController.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SnapNShareHomeViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties
    var presenter: SnapNShareHomePresentation?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}

extension SnapNShareHomeViewController: SnapNShareHomeView {
    func initView() {
        customizeNavigationItem(title: "Restaurant Checkin", isDetailPage: false)
    }
}

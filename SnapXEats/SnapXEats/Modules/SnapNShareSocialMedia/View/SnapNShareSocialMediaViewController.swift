//
//  SnapNShareSocialMediaViewController.swift
//  SnapXEats
//
//  Created by synerzip on 16/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SnapNShareSocialMediaViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties
    var presenter: SnapNShareSocialMediaPresentation?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}

extension SnapNShareSocialMediaViewController: SnapNShareSocialMediaView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: true)
    }
}

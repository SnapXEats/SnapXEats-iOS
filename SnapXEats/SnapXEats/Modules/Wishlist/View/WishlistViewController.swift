//
//  WishlistViewController.swift
//  SnapXEats
//
//  Created by synerzip on 02/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class WishlistViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: WishlistPresentation?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}

extension WishlistViewController: WishlistView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.wishlist, isDetailPage: false)
    }
}

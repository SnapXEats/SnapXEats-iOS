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

    @IBOutlet var wishlistTableView: UITableView!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}

extension WishlistViewController: WishlistView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.wishlist, isDetailPage: false)
        registerNibForCell()
    }
    
    private func registerNibForCell() {
        let tableViewCellNib = UINib(nibName: SnapXEatsNibNames.wishlistItemTableViewCell, bundle: nil)
        wishlistTableView.register(tableViewCellNib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.wishlistTableView)
    }
}

extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.wishlistTableView, for: indexPath) as! WishlistItemTableViewCell
        return cell
    }
}

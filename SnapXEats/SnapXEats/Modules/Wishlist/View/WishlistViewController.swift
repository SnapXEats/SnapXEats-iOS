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
    var wishItems = [WishListData]()
    @IBOutlet var wishlistTableView: UITableView!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendWishListRequest()
    }
    
    private func sendWishListRequest() {
        if checkRechability() {
            showLoading()
            presenter?.getWishListRestaurantDetails()
        }
    }
    
    override func success(result: Any?) {
        if let result = result as? WishList {
            if let listData = result.wishList {
             wishItems = listData
             wishlistTableView.reloadData()
            }
        }
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
        return wishItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.wishlistTableView, for: indexPath) as! WishlistItemTableViewCell
         cell.setWishListItem(item: wishItems[indexPath.row])
        return cell
    }
}

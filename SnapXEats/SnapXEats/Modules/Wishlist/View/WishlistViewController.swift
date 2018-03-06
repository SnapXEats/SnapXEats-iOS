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

    private enum navigationRightButtonTitles {
        static let edit = "Edit"
        static let delete = "Delete"
    }
    
    // MARK: Properties
    var presenter: WishlistPresentation?
    var wishItems = [WishListData]()
    var isEditable = false
    var menuBarButtonItem: UIBarButtonItem?
    var selectedIndexes = NSMutableArray()
    
    @IBOutlet var wishlistTableView: UITableView!
    
    @IBAction func navigationRightBarButtonClicked(_ sender: Any) {
        isEditable ? makeWishlistNonEditable() : makeWishlistEditable()
    }
    
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
        menuBarButtonItem = self.navigationItem.leftBarButtonItem
    }
    
    private func registerNibForCell() {
        let tableViewCellNib = UINib(nibName: SnapXEatsNibNames.wishlistItemTableViewCell, bundle: nil)
        wishlistTableView.register(tableViewCellNib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.wishlistTableView)
    }
    
    private func makeWishlistEditable() {
        isEditable = true
        self.navigationItem.rightBarButtonItem?.title = navigationRightButtonTitles.delete
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: SnapXEatsImageNames.closeIcon), style: .plain, target: self, action: #selector(cancelEditing))
    }
    
    @objc func cancelEditing() {
        makeWishlistNonEditable()
    }
    
    private func makeWishlistNonEditable() {
        isEditable = false
        self.navigationItem.rightBarButtonItem?.title = navigationRightButtonTitles.edit
        self.navigationItem.leftBarButtonItem = menuBarButtonItem
        selectedIndexes.removeAllObjects()
        wishlistTableView.reloadData()
    }
}

extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.wishlistTableView, for: indexPath) as! WishlistItemTableViewCell
        cell.selectionStyle = .none
        let isItemSelected = selectedIndexes.contains(indexPath.row) ? true : false
        cell.setWishListItem(item: wishItems[indexPath.row], isSelected: isItemSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditable { // allow Multiple Selection for Delete only if Wishlist is Editable
            selectedIndexes.contains(indexPath.row) ? selectedIndexes.remove(indexPath.row)
                : selectedIndexes.add(indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

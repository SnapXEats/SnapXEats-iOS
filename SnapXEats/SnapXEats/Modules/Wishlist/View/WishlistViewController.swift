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
    var wishItems = [WishListItem]()
    var isEditable = false
    var menuBarButtonItem: UIBarButtonItem?
    var selectedIndexes = NSMutableArray()
    
    @IBOutlet var wishlistTableView: UITableView!
    
    @IBAction func navigationRightBarButtonClicked(_ sender: Any) {
        if  isEditable  {
            selectedIndexes.count > 0 ?  showDeleteDialog() : makeWishlistNonEditable()
        }
        else {
            makeWishlistEditable()
        }
    }
    
    private func showDeleteDialog() {
        let ok =  setOkButton(title: SnapXButtonTitle.ok) { [weak self] in
            self?.deleteWishListItems()
            self?.makeWishlistNonEditable()
        }
        let cancel = setCancelButton { [weak self] in
            self?.selectedIndexes.removeAllObjects()
            self?.makeWishlistNonEditable()
        }
        
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.error , message: AlertMessage.deleteWishListMessage, actions: [cancel, ok], completion: nil)
    }
    
    private func setCancelButton(completionHandler: @escaping () ->()) -> UIAlertAction {
        return UIAlertAction(title: SnapXButtonTitle.cancel, style: UIAlertActionStyle.default, handler: {action in completionHandler()})
        
    }
    
    private func setOkButton(title: String, completionHandler: @escaping () ->()) -> UIAlertAction {
        return UIAlertAction(title: title, style: UIAlertActionStyle.default, handler:  {action in completionHandler()})
    }
    
    private func enableBarButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled =  wishItems.count == 0 ? false : true
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
        if checkRechability() && !isProgressHUD {
            showLoading()
            presenter?.getWishListRestaurantDetails()
        }
    }
    
    override func success(result: Any?) {
        if let result = result as? WishList {
            if let listData = result.wishList {
                wishItems = listData
                wishlistTableView.reloadData()
                enableBarButton()
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
        selectedIndexes.removeAllObjects()
        makeWishlistNonEditable()
    }
    
    private func makeWishlistNonEditable() {
        isEditable = false
        self.navigationItem.rightBarButtonItem?.title = navigationRightButtonTitles.edit
        self.navigationItem.leftBarButtonItem = menuBarButtonItem
        wishlistTableView.reloadData()
    }
    
    private func deleteWishListItems() {
        var deleteWishList = [WishListItem]()
        for (_, item) in selectedIndexes.enumerated() {
            let deleteIndex  = item as! Int
            let item = wishItems[deleteIndex]
            deleteWishList.append(item)
        }
        removeItem(deleteWishList: deleteWishList)
        presenter?.deleteWishListItems(items: deleteWishList)
    }
    
    private func removeItem(deleteWishList: [WishListItem]) {
        for  item in deleteWishList {
            if let index = wishItems.enumerated().filter( { $0.element === item }).map({ $0.offset }).first {
                wishItems.remove(at: index)
            }
        }
        selectedIndexes.removeAllObjects()
        enableBarButton()
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
        } else {
            loadRestaurantDetails(item: wishItems[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            presenter?.deleteWishListItem(item: wishItems[indexPath.row])
            wishItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            enableBarButton()
        }
    }
    
    func loadRestaurantDetails(item: WishListItem) {
        // Restaurant Detail Action
        if let parent = self.navigationController {
            presenter?.gotoRestaurantDetails(selectedRestaurant: item.restaurant_info_id, parent: parent, showMoreInfo: false)
        }
    }
}

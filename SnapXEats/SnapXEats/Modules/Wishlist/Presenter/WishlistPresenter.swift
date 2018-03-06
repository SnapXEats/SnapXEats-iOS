//
//  WishlistPresenter.swift
//  SnapXEats
//
//  Created by synerzip on 02/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

class WishlistPresenter {

    // MARK: Properties
    weak var baseView: BaseView?
    weak var view: WishlistView?
    var router: WishlistWireframe?
    var interactor: WishlistUseCase?
    
    static let shared = WishlistPresenter()
    private init() {}
}

extension WishlistPresenter: WishlistPresentation {
    func deleteWishListItem(item: WishListItem) {
        interactor?.removeWishListItem(item: item)
    }
    
    func deleteWishListItems(items: [WishListItem]) {
        interactor?.removeWishListItems(items: items)
    }
    
    func getWishListRestaurantDetails() {
        interactor?.getWishListRestaurantDetails()
    }

}

extension WishlistPresenter: WishlistInteractorOutput {
    // TODO: implement interactor output methods
}

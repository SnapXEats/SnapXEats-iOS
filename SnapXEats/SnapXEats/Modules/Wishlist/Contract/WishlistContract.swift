//
//  WishlistContract.swift
//  SnapXEats
//
//  Created by synerzip on 02/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire


protocol WishlistView: BaseView {
      var presenter: WishlistPresentation? { set get }
}

protocol WishlistPresentation {
        func getWishListRestaurantDetails()
        func deleteWishListItem(item: WishListItem)
        func deleteWishListItems(items: [WishListItem])
}

protocol WishlistUseCase: WishlistRequestFormatter {
    func sendUserWishList()
    func removeWishListItem(item: WishListItem)
    func removeWishListItems(items: [WishListItem])
}

protocol WishlistInteractorOutput: Response {

}

protocol WishlistWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}


protocol WishlistRequestFormatter: class {
     func getWishListRestaurantDetails()
}

protocol WishlistWebService: class {
    func sendWishListDetailsRequest(path: String)
    func sendUserGesturesRequest(forPath: String, withParameters: [String: Any], completionHandler: @escaping (_ response: DefaultDataResponse) -> ())
}

protocol WishlistObjectMapper: class {
    func wishListDetails(data: Result<WishList>)
}

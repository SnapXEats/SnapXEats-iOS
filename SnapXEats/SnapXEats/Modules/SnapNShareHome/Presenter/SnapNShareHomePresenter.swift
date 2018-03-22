//
//  SnapNShareHomePresenter.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SnapNShareHomePresenter {

    // MARK: Properties
    weak var baseView: BaseView?
    var router: SnapNShareHomeWireframe?
    var interactor: SnapNShareHomeRequestFormatter?
    
    static let shared = SnapNShareHomePresenter()
    private init() {}
}

extension SnapNShareHomePresenter: SnapNShareHomePresentation {
    func gotoSnapNSharePhotoView(parent: UINavigationController, withPhoto photo: UIImage) {
        router?.presentScreen(screen: .snapNSharePhoto(photo: photo, iparentController: parent))
    }
    
    func restaurantDetailsRequest(restaurantId: String) {
        interactor?.getRestaurantDetailsRequest(restaurant_id: restaurantId)
    }
}

extension SnapNShareHomePresenter: SnapNShareHomeInteractorOutput {
    // TODO: implement interactor output methods
}

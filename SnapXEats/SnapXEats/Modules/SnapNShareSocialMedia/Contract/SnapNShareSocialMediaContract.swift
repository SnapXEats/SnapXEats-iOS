//
//  SnapNShareSocialMediaContract.swift
//  SnapXEats
//
//  Created by synerzip on 16/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

protocol SnapNShareSocialMediaView: BaseView {
    // TODO: Declare view methods
}

protocol SnapNShareSocialMediaPresentation: class {
    func presentScreen(screen: Screens)
    func loginUsingFaceBook()
    func sendPhotoReview(restaurantID: String, smartPhoto_Draft_Stored_id: String)
}

protocol SnapNShareSocialMediaUseCase: SnapNShareSocialMediaInPut {
    
}

protocol SnapNShareSocialMediaInPut: SnapNShareSocialMediaRequestFomatter {
   func sendFaceBookLoginRequest(view: BaseView?)
}

protocol SnapNShareSocialMediaInteractorOutput: Response {
    // TODO: Declare interactor output methods
}


protocol SnapNShareSocialMediaRequestFomatter: class {
    func uploadDishReview(restaurantID: String, smartPhoto_Draft_Stored_id: String)
}

protocol SnapNShareSocialMediaWebService: class {
    func sendReviewRequest(path: String, parameters:[String: Any])
}

protocol SnapNShareSocialMediaObjectMapper: class {
    func reviewDetails(data: Result<SnapNShare> )
}


protocol SnapNShareSocialMediaWireframe: RootWireFrame {
    // TODO: Declare wireframe methods
}



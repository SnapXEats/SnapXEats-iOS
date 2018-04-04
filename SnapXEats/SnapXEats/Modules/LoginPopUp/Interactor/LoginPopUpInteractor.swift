//
//  LoginPopUpInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 04/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore
import Alamofire
import ObjectMapper

class LoginPopUpInteractor {

    // MARK: Properties
    
    var output: LoginPopUpInteractorOutput?
    private init() {}
    static let shared = LoginPopUpInteractor()
}

extension LoginPopUpInteractor: LoginPopUpInteractorInPut {
    
    func sendLoginFaceBook(view: UIViewController) {
        if  let view = view as? LoginPopUpViewController, view.checkRechability() {
            let loginManager = LoginManager()
            loginManager.logIn(publishPermissions: [.publishActions], viewController: view) { [weak self] loginResult in
                switch loginResult {
                case .failed( _):
                    self?.output?.response(result: NetworkResult.error)
                case .cancelled:
                    self?.output?.response(result: NetworkResult.cancelRequest)
                case .success( _, _, let accessToken):
                    
                    self?.output?.response(result: .success(data: true))
                }
            }
        }
    }
    
    func sendLoginInstagram() {
        
    }
    
    // TODO: Implement use case methods
}

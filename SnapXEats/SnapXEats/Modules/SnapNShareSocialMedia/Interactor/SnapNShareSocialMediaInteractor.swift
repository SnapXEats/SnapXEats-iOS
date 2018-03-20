//
//  SnapNShareSocialMediaInteractor.swift
//  SnapXEats
//
//  Created by synerzip on 16/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore


class SnapNShareSocialMediaInteractor {

    var output: SnapNShareSocialMediaInteractorOutput?
}


extension SnapNShareSocialMediaInteractor: SnapNShareSocialMediaUseCase {
    func sendFaceBookLoginRequest(view: BaseView?) {
        if  let view = view as? SnapNShareSocialMediaViewController, view.checkRechability() {
            let loginManager = LoginManager()
            loginManager.logIn(publishPermissions: [.publishActions], viewController: view) { [weak self] loginResult in
                switch loginResult {
                case .failed( _):
                    self?.output?.response(result: NetworkResult.error)
                case .cancelled:
                    self?.output?.response(result: NetworkResult.cancelRequest)
                case .success( _, _, let accessToken):
                    SocialPlatformHelper.shared.saveSecondSocialLoginInfoAsFB(accessToken: accessToken)
                    self?.output?.response(result: .success(data: true))
                }
            }
        }
    }
}

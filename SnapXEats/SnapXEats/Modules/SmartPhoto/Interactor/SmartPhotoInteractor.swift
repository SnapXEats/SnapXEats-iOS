//
//  smartPhotoInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

class SmartPhotoInteractor {
    weak var output: SmartPhotoInteractorOutput?
    static let shared = SmartPhotoInteractor()
    private init () {}
}

extension SmartPhotoInteractor: SmartPhotoUseCase {
    func sendSmartPhotoRequest(dishID: String) {
        let paraMeter = [ SnapXEatsWebServiceParameterKeys.restaurant_dish_id: dishID]
        smartPhotoRequest(forPath: SnapXEatsWebServicePath.dishesURL, parameters: paraMeter)
    }
}


extension SmartPhotoInteractor: SmartPhotoWebService {

    func smartPhotoRequest(forPath: String, parameters: [String: Any]) {
        SnapXEatsApi.snapXRequestObjectWithParameters(path: forPath, parameters: parameters) { [weak self](response: DataResponse<SmartPhoto>) in
            let smartPhoto = response.result
            self?.smartPhotoDetail(data: smartPhoto)
        }
    }
}

extension SmartPhotoInteractor: SmartPhotoObjectMapper {
    func smartPhotoDetail(data: Result<SmartPhoto>) {
        switch data {
        case .success(let value):
            output?.response(result: .success(data: value))
        case .failure( _):
            output?.response(result: NetworkResult.noInternet)
        }
    }
}



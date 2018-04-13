//
//  smartPhotoContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

protocol SmartPhotoView: BaseView {
    var presenter: SmartPhotoPresentation? {get set}
    
}

protocol SmartPhotoPresentation: SuccessScreen {
     func getSmartPhotoDetails(dishID: String)
     func presentView(view: SmartPhotView)
     func pausePlayAudio()
}

protocol SmartPhotoUseCase: SmartPhotoFormatter {
    // TODO: Declare use case methods
}

protocol SmartPhotoFormatter: class {
    func sendSmartPhotoRequest(dishID: String)
}

protocol SmartPhotoWebService: class {
    func smartPhotoRequest(forPath: String, parameters: [String: Any])
}

protocol SmartPhotoObjectMapper: class {
   func smartPhotoDetail(data: Result<SmartPhoto>)
}

protocol SmartPhotoInteractorOutput: Response {
    // TODO: Declare interactor output methods
}

protocol SmartPhotoWireframe: RootWireFrame {
    func presentSmartPhotoView(view: SmartPhotView)
    func pausePlayAudio()
    func checkInternet() -> Bool
}

//
//  smartPhotoContract.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire

enum SmartPhotView {
    case info, message, audio, download, success
}

protocol SmartPhotoView: BaseView {
    var presenter: SmartPhotoPresentation? {get set}
    
}

protocol SmartPhotoPresentation: class {
     func getSmartPhotoDetails(dishID: String)
     func presentView(view: SmartPhotView)
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
}

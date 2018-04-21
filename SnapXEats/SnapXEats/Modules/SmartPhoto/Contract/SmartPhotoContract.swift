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
     func presentScreen(screen: Screens)
     func saveSmartPhoto(smartPhoto: SmartPhoto)
     func checkSmartPhoto(smartPhotoID: String) -> Bool
}

protocol SmartPhotoUseCase: SmartPhotoFormatter {
    func storeSmartPhoto(smartPhoto: SmartPhoto)
}

protocol SmartPhotoFormatter: class {
    func sendSmartPhotoRequest(dishID: String)
    func alreadyExistingSmartPhoto(smartPhotoID: String) -> Bool
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

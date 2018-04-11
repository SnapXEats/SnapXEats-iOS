//
//  smartPhotoRouter.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

enum SmartPhotView {
    case info(photoInfo: SmartPhoto), textReview(textReview: String), audio, download, success
}


class SmartPhotoRouter {
    
    // MARK: Properties
    
    weak var view: SmartPhotoViewController?
    
    static let shared = SmartPhotoRouter()
    
    private init () {}
    
    func loadModule() -> SmartPhotoViewController {
        let viewController = UIStoryboard.loadViewController() as SmartPhotoViewController
        let presenter = SmartPhotoPresenter.shared
        let router = SmartPhotoRouter.shared
        let interactor = SmartPhotoInteractor.shared
        
        viewController.presenter =  presenter
        
        presenter.baseView = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        router.view = viewController
        
        interactor.output = presenter
        
        return viewController
    }
    
    func initView(configView: UIView) {
        if let view =  view?.containerView {
            self.view?.removeSubView()
            view.isHidden = false
            let frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
            configView.frame = frame
            view.addSubview(configView)
        }
    }
    
    private func loadNib(nimName: String) -> UIView? {
        return UINib(nibName: nimName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    private func loadInfoView(photInfo: SmartPhoto) {
        if let smartPhotoInfo = loadNib(nimName: SnapXEatsNibNames.smartPhotoInfo) as? SmartPhotoInfo {
            smartPhotoInfo.smartPhotoInfo = photInfo
            smartPhotoInfo.initView()
            initView(configView: smartPhotoInfo)
        }
    }
    
    private func loadTextView(textReview: String) {
        if let textView = loadNib(nimName: SnapXEatsNibNames.smartPhotoMessage) as? SmartPhotoTextReview {
            textView.textReview = textReview
            textView.initView()
            initView(configView: textView)
        }
    }
    
    private func loadAudioView() {
        if let audioView = loadNib(nimName: SnapXEatsNibNames.smartPhotoAudio) as? SmartPhotoAudio {
            initView(configView: audioView)
        }
    }
    
    private func loadDownloadView() {
        if let downloadView = loadNib(nimName: SnapXEatsNibNames.smartPhotoDownload) as? SmartPhotoDownload {
            initView(configView: downloadView)
        }
    }
    private func loadDownloadSuccessView() {
        if let successView = loadNib(nimName: SnapXEatsNibNames.smartPhotoSuccess) as? SmartPhotoDownloadSuccess {
            initView(configView: successView)
        }
    }
}

extension SmartPhotoRouter: SmartPhotoWireframe {
    func presentSmartPhotoView(view: SmartPhotView) {
        switch view {
        case .info(let photoInfo):
            presentInfoView(smartPhotInfo: photoInfo)
        case .audio:
            presentAudioReview()
        case .textReview(let textReview):
            presentTextReview(textReview: textReview)
        case .download:
            presentDownLoadView()
        case .success:
            presentSuccessView()
        }
    }
    
    private func presentInfoView(smartPhotInfo: SmartPhoto) {
        loadInfoView(photInfo: smartPhotInfo)
    }
    
    private func presentTextReview(textReview: String) {
        loadTextView(textReview: textReview)
    }
    
    private func presentAudioReview() {
        loadAudioView()
    }
    
    private func presentDownLoadView() {
        loadDownloadView()
    }
    
    func presentSuccessView() {
        loadDownloadSuccessView()
    }
}

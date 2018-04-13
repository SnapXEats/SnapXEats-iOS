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
    case info(photoInfo: SmartPhoto), textReview(textReview: String), audio(audioURL: String), download(imageURL: String, audioURL: String?), success
}

enum CurrentViewType {
    case info, textReview, audio, download, success
}


class SmartPhotoRouter {
    
    // MARK: Properties
    
    weak var view: SmartPhotoViewController?
    
    static let shared = SmartPhotoRouter()
    
    private init () {}
    
    private var containerViewType: CurrentViewType?
    private var containerView: UIView?
    
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
            containerViewType = .info
            containerView = smartPhotoInfo
            setContainerView(view: smartPhotoInfo, type: .info)
            initView(configView: smartPhotoInfo)
        }
    }
    
    private func loadTextView(textReview: String) {
        if let textView = loadNib(nimName: SnapXEatsNibNames.smartPhotoMessage) as? SmartPhotoTextReview {
            textView.textReview = textReview
            textView.initView()
            setContainerView(view: textView, type: .textReview)
            initView(configView: textView)
        }
    }
    
    private func loadAudioView(audioURL: String) {
        if let audioView = loadNib(nimName: SnapXEatsNibNames.smartPhotoAudio) as? SmartPhotoAudio {
            audioView.audioURL = audioURL
            audioView.initView()
            audioView.delegate = self
            setContainerView(view: audioView, type: .audio)
            initView(configView: audioView)
        }
    }
    
    private func loadDownloadView(imageURL: String, audioURL: String?) {
        if let downloadView = loadNib(nimName: SnapXEatsNibNames.smartPhotoDownload) as? SmartPhotoDownload {
            downloadView.imageURL = imageURL
            downloadView.audioURL = audioURL
            downloadView.delegate = view?.presenter
            downloadView.internetdelegate = self
            downloadView.initView()
            setContainerView(view: downloadView, type: .download)
            initView(configView: downloadView)
        }
    }
    private func loadDownloadSuccessView() {
        if let successView = loadNib(nimName: SnapXEatsNibNames.smartPhotoSuccess) as? SmartPhotoDownloadSuccess {
            initView(configView: successView)
        }
    }
    
    func setContainerView(view: UIView, type: CurrentViewType) {
        if let containerView = containerView as? SmartPhotoAudio {
            containerView.pausePlayer()
        }
        containerViewType = type
        containerView = view
    }
}

extension SmartPhotoRouter: SmartPhotoWireframe {
    func presentSmartPhotoView(view: SmartPhotView) {
        switch view {
        case .info(let photoInfo):
            presentInfoView(smartPhotInfo: photoInfo)
        case .audio(let audioURL):
            presentAudioReview(audioURL: audioURL)
        case .textReview(let textReview):
            presentTextReview(textReview: textReview)
        case .download(let imageURL, let audioURL):
            presentDownLoadView(imageURL: imageURL, audioURL: audioURL)
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
    
    private func presentAudioReview(audioURL: String) {
        loadAudioView(audioURL: audioURL)
    }
    
    private func presentDownLoadView(imageURL: String, audioURL: String?) {
        loadDownloadView(imageURL: imageURL, audioURL: audioURL)
    }
    
    func presentSuccessView() {
        loadDownloadSuccessView()
    }
    
    func pausePlayAudio() {
        if let containerView = containerView as? SmartPhotoAudio {
            containerView.pausePlayer()
        }
    }
    
    func checkInternet() -> Bool {
        if let view = view  {
         return view.checkRechability()
        }
        return false
    }
}

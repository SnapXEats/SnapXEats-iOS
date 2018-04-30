//
//  RestaurantDetailsRouter.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation
import UIKit

class RestaurantDetailsRouter {

    // MARK: Properties
    
    weak var view: RestaurantDetailsViewController?
    private var containerView: UIView?

    private init() {}
    static let shared = RestaurantDetailsRouter()

    func loadRestaurantDetailsModule() -> RestaurantDetailsViewController {
        let viewController = UIStoryboard.loadViewController() as RestaurantDetailsViewController
        
        let presenter = RestaurantDetailsPresenter.shared
        let router = RestaurantDetailsRouter.shared
        let interactor = RestaurantDetailsInteractor.shared

        viewController.presenter =  presenter

        presenter.view = viewController
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
    
    private func loadDownloadSuccessView() {
        if let successView = loadNib(nimName: SnapXEatsNibNames.smartPhotoSuccess) as? SmartPhotoDownloadSuccess {
            initView(configView: successView)
        }
    }
    
    func presentSuccessView() {
        view?.actionButtonsView.downloadButton.isHidden = true // hide the download button after success
        loadDownloadSuccessView()
    }
    
    func setContainerView(view: UIView, type: CurrentViewType) {
        containerView = view
    }
}

extension RestaurantDetailsRouter: RestaurantDetailsWireframe {

    func presentSmartPhotoView(view: SmartPhotView) {
        switch view {
        case .download(let smartPhoto):
            presentDownLoadView(smartPhoto: smartPhoto!)
        case .success:
            presentSuccessView()
        case .info( _): break
            
        case .textReview( _): break
            
        case .audio( _): break
            
        }
    }
    
    
    private func presentDownLoadView(smartPhoto: SmartPhoto) {
        loadDownloadView(smartPhoto: smartPhoto)
    }
    
    private func loadDownloadView(smartPhoto:  SmartPhoto?) {
        if let downloadView = loadNib(nimName: SnapXEatsNibNames.restaurantInfoDownload) as? RestaurantInfoDownload {
            downloadView.smartPhoto = smartPhoto
            downloadView.delegate = view?.presenter
            downloadView.internetdelegate = self
            downloadView.initView()
            setContainerView(view: downloadView, type: .download)
            initView(configView: downloadView)
        }
    }
    
    func checkInternet() -> Bool {
        if let view = view  {
            return view.checkRechability()
        }
        return false
    }
}

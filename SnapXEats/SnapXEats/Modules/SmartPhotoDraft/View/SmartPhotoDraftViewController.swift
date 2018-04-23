//
//  SmartPhotoDraftViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 14/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SmartPhotoDraftViewController: BaseViewController, StoryboardLoadable {
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    // MARK: Properties
    var smartPhoto_Draft_Stored_id: String?  = getTimeInterval()
    var presenter: SmartPhotoDraftPresentation?
    var enableSmartPhoto: Bool {
        return SmartPhotoHelper.shared.hasSmartPhotos()
    }
    
    var enableDraft: Bool {
        return SmartPhotoHelper.shared.hasDraftPhotos()
    }
    // MARK: Lifecycle

    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func shareButtonAction(_ sender: Any) {
        if let smartPhoto_Draft_Stored_id = smartPhoto_Draft_Stored_id,  smartPhoto_Draft_Stored_id != SnapXEatsConstant.emptyString, let parent = self.navigationController {
            presenter?.presentScreen(screen: .snapNShareSocialMedia(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: parent))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentView.selectedSegmentIndex
        {
        case 0:
            loadView(screen: .smartPhoto)
        //show popular view
        case 1:
            loadView(screen: .draft)
        default:
            break;
        }
    }
    
    func loadView(screen: DraftScreen) {
        if  let smartPhotoView = presenter?.presentView(screen: screen) {
            addControllerToContainerView(smartPhotoView)
        }
    }
}

extension SmartPhotoDraftViewController: SmartPhotoDraftView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.smartPhotos, isDetailPage: false)
        configureSegment()
    }
    
    func configureSegment() {
        let hasPhoto = enableSmartPhoto
        let hasDraft = enableDraft
        if hasPhoto == false {
            segmentView.setEnabled(hasPhoto, forSegmentAt: 0)
            segmentView.selectedSegmentIndex = 1
            loadView(screen: .draft)
        } else {
            segmentView.selectedSegmentIndex = 0
            loadView(screen: .smartPhoto)
        }
        
        if hasDraft == false {
            segmentView.setEnabled(hasDraft, forSegmentAt: 1)
        }
    }
    
    fileprivate func addControllerToContainerView(_ viewController: UIViewController) {
        let oldViewContollers = self.childViewControllers
        if oldViewContollers.count > 0 {
            oldViewContollers[0].removeFromParentViewController()
        }
        addChildViewController(viewController)
        viewController.view.frame = CGRect(x: 0.0, y: 0.0,width: containerView.frame.size.width, height: containerView.frame.size.height)
        removeSubviewsFromContainerView()
        containerView.addSubview(viewController.view)
    }
    
    /**
     Remove previous subviews from container view when new view loading
     
     - returns: Void
     */
    fileprivate func removeSubviewsFromContainerView() {
        for subview in self.containerView.subviews {
            if !(subview is UILayoutSupport) {
                subview.removeFromSuperview()
            }
        }
    }
    // TODO: implement view output methods
}

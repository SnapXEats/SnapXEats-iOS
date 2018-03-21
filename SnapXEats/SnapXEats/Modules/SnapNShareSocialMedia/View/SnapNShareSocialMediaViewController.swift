//
//  SnapNShareSocialMediaViewController.swift
//  SnapXEats
//
//  Created by synerzip on 16/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import FacebookShare
import SwiftInstagram

class SnapNShareSocialMediaViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties
    var presenter: SnapNShareSocialMediaPresentation?
    
    let loginPreferecne = LoginUserPreferences.shared
    let instagramApi = Instagram.shared
    
    @IBOutlet weak var fbButton: UIButton!
    // MARK: Lifecycle
    @IBOutlet weak var instagramButton: UIButton!

    @IBAction func fbImageShare(_ sender: Any) {
        if loginPreferecne.fbSharingenabled {
            // if already loggedin (FB or instagram) and Fb sharing is enabled
            sharingDialogFB()
        } else {
             presenter?.loginUsingFaceBook()
        }
    }
    
    @IBAction func instagramImageShare(_ sender: Any) {
//        if loginPreferecne.isInstagramlogin {
//
//        } else {
//            presenter?.presentScreen(screen: .instagram)
//        }
        sharingDialogInstagram()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func success(result: Any?) {
        if let _ = result as? Bool {
            sharingDialogFB()
        }
    }
    
    func getUsrImage() -> String {
        return "https://s3.us-east-2.amazonaws.com/snapxeats/french.jpg"
    }
    
    func sharingDialogFB() {
        let content = LinkShareContent(url: URL(string: getUsrImage())!)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .automatic
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            switch result {
            case .failed(let value ):
                print("falied \(value.localizedDescription)")
            case .cancelled:
                print("canecel")
            case .success:
                print("Success")
            }
        }
        try! shareDialog.show()
    }
    
    func sharingDialogInstagram() {
        if let image = UIImage(named: SnapXEatsImageNames.placeholder_cuisine) {
            InstagramManager.shared.shareONInstagram(image: image, description: "This is the image on Instagram", viewController: self)
        }
    }
}

extension SnapNShareSocialMediaViewController: SnapNShareSocialMediaView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: true)
    }
}

    



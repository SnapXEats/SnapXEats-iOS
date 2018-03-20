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
import FBSDKShareKit
import FacebookCore

class SnapNShareSocialMediaViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties
    var presenter: SnapNShareSocialMediaPresentation?
    
    let loginPreferecne = LoginUserPreferences.shared
    
    @IBOutlet weak var fbButton: UIButton!
    // MARK: Lifecycle
    @IBOutlet weak var instagramButton: UIButton!

    @IBAction func fbImageShare(_ sender: Any) {
        if loginPreferecne.fbSharingenabled {
            // if already loggedin (FB or instagram) and Fb sharing is enabled
            sharingDialog()
        } else {
             presenter?.loginUsingFaceBook()
        }
//        if let platForm = loginPreferecne.loginPlatform, platForm == SnapXEatsConstant.platFormFB {
//            // if logged in using Fb but sharing is not enabled we need to login with sharing enabled
//            presenter?.loginUsingFaceBook()
//        } else {
//             // if logged in using instagram but want to share photo on FB then need to login with sharing enabled
//            presenter?.loginUsingFaceBook()
//        }
    }
    
    @IBAction func instagramImageShare(_ sender: Any) {
        if loginPreferecne.isInstagramlogin {
            
        } else {
            presenter?.presentScreen(screen: .instagram)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func success(result: Any?) {
        if let value = result as? Bool {
            sharingDialog()
        }
    }
    
    func getUsrImage() -> String {
        return "https://s3.us-east-2.amazonaws.com/snapxeats/french.jpg"
    }
}

extension SnapNShareSocialMediaViewController: SnapNShareSocialMediaView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: true)
    }
}

extension SnapNShareSocialMediaViewController: FBSDKSharingDelegate {
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("Success")
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
         print("Error")
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print ("Is Canceled")
    }
    
    func sharingDialog() {
        
        let photo = Photo.init(url: URL(string: getUsrImage())!, userGenerated: false)
        
        var content = PhotoShareContent()
        content.photos = [photo]
        
        let content1 = LinkShareContent(url: URL(string: getUsrImage())!)
        
        let shareDialog = ShareDialog(content: content1)
        shareDialog.mode = .native
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
    
}

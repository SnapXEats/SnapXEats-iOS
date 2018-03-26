//
//  InstagramManager.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 21/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

import UIKit
import Photos

//https://stackoverflow.com/questions/11393071/how-to-share-an-image-on-instagram-in-ios
class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let kInstagramURL = "instagram://"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application first to share your photo"
    
    var documentInteractionController = UIDocumentInteractionController()
    
    // singleton manager
    class var shared: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }
    
    private func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, viewController: UIViewController) {
        // called to post image with caption to the instagram application
        
        let instagramURL = URL(string: kInstagramURL)
        if UIApplication.shared.canOpenURL(instagramURL!) {
            let image = imageInstagram.stretchableImage(withLeftCapWidth: 640, topCapHeight: 640)
    
            do {
                try PHPhotoLibrary.shared().performChangesAndWait {
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
                    let shareURL = URL(string: "instagram://library?LocalIdentifier=" + assetID)
                    if let urlForRedirect = shareURL {
                        UIApplication.shared.openURL(urlForRedirect)
                    }
                }
            } catch {
                print("NO result")
            }
        }
        else {
            
            let okAction = UIAlertAction(title: SnapXButtonTitle.ok, style: .default, handler: nil)
            UIAlertController.presentAlertInViewController(viewController, title: kAlertViewTitle, message: kAlertViewMessage, actions: [okAction], completion: nil)
        }
    }
    
    func shareONInstagram(image: UIImage, description: String, viewController: UIViewController){
        postImageToInstagramWithCaption(imageInstagram: image, instagramCaption: "\(description)", viewController: viewController)
    }
    
}



//
//  SnapNShareHomeViewController.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SnapNShareHomeViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties
    var presenter: SnapNShareHomePresentation?
    var picker = UIImagePickerController()
    
    @IBAction func takeSnapButtonAction(_ sender: UIButton) {
        openCameraPicker()
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func openCameraPicker() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func gotoSnapNSharePhotoViewWithPhoto(photo: UIImage) {
        if let parentNVCpntroller = self.navigationController {
            presenter?.gotoSnapNSharePhotoView(parent: parentNVCpntroller, withPhoto: photo)
        }
    }
}

extension SnapNShareHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            dismiss(animated: true) {
                self.gotoSnapNSharePhotoViewWithPhoto(photo: chosenImage)
            }
        }
    }
}

extension SnapNShareHomeViewController: SnapNShareHomeView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: false)
        picker.delegate = self
    }
}

//
//  CameraPicker.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 24/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class CamerPicker {
    static let picker = UIImagePickerController()
    static func camperPicker(view: UIViewController) {

            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.cameraCaptureMode = .photo
                view.present(picker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                alert.addAction(ok)
                view.present(alert, animated: true, completion: nil)
            }
        }

}

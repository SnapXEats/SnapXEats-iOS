//
//  UIAlertController.swift
//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    // MARK: - Utils
    
    static func presentActionSheetInViewController(_ viewController: UIViewController,
                                                   title: String?,
                                                   message: String?,
                                                   actions: [UIAlertAction],
                                                   completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        viewController.present(alertController, animated: true, completion: completion)
    }
    
    static func presentAlertInViewController(_ viewController: UIViewController,
                                             title: String?,
                                             message: String?,
                                             actions: [UIAlertAction],
                                             completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        viewController.present(alertController, animated: true, completion: completion)
    }
}

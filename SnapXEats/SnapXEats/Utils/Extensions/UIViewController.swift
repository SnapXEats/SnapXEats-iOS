//
//  UIViewController.swift
//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func findActiveTextField(_ subviews : [UIView]) -> UITextField? {
        for view in subviews {
            if let textField = view as? UITextField {
                if textField.isFirstResponder {
                    return textField
                }
            } else if !view.subviews.isEmpty {
                if let childTextField = findActiveTextField(view.subviews) {
                    return childTextField
                }
            }
        }
        return nil
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func findTopmostViewController() -> UIViewController {
        if let parentViewController = parent {
            return parentViewController.findTopmostViewController()
        } else {
            return self
        }
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}

extension UIViewController { // Navigation Item Customizations

    func customizeNavigationItem(title: String = "", isDetailPage: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.backBarButtonItem?.title = nil
        self.navigationItem.title = title
        
        
        if isDetailPage == false {
            // Left Button - Menu
            self.navigationItem.leftBarButtonItem = setMenuButton()
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        let leftItem: UIBarButtonItem = UIBarButtonItem()
        leftItem.title = ""
        self.navigationItem.backBarButtonItem = leftItem
    }
    
    private func setTitleLogo() -> UIImageView {
        let titleLogoImage = UIImageView(frame: CGRect(x:0, y:0, width: 134, height: 30))
        titleLogoImage.contentMode = .scaleAspectFit
        titleLogoImage.image = UIImage(named: SnapXEatsImageNames.navigationLogo)
        return titleLogoImage
    }
    
    
    private func setMenuButton() -> UIBarButtonItem {
        let menuButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 18))
        menuButton.setImage(UIImage(named: SnapXEatsImageNames.navigationMenu), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: UIControlEvents.touchUpInside)
        return  UIBarButtonItem(customView: menuButton)
    }
    

    @objc func menuButtonTapped() {
        //Menu Button Action
        RootRouter.shared.updateDrawerState(state: .opened)
    }
    
    @objc func serarchButtonTapped() {
        //Search Button Action
    }
}
extension UIViewController: ReusableView { }


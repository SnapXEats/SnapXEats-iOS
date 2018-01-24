//
//  FoodCardsViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class FoodCardsViewController: BaseViewController, StoryboardLoadable {

    var presenter: FoodCardsPresentation?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationItem()
    }
    
    //TODO: We can make this method comman for all NavigationItems if same UI is needed
    private func customizeNavigationItem() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.backBarButtonItem?.title = nil
        
        // Navigation Title Logo
        let titleLogoImage = UIImageView(frame: CGRect(x:0, y:0, width: 134, height: 30))
        titleLogoImage.contentMode = .scaleAspectFit
        titleLogoImage.image = UIImage(named: "snapx_logo_orange")
        self.navigationItem.titleView = titleLogoImage
        
        // Left Button - Menu
        let menuButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 18))
        menuButton.setImage(UIImage(named:"navigation_menu_icon"), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: UIControlEvents.touchUpInside)
        let menuBarButton : UIBarButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.leftBarButtonItem = menuBarButton
        
        // Right Button - Search
        let serarchButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
        serarchButton.setImage(UIImage(named: "navigation_search_icon"), for: UIControlState.normal)
        serarchButton.addTarget(self, action: #selector(serarchButtonTapped), for: UIControlEvents.touchUpInside)
        let rightBarButton : UIBarButtonItem = UIBarButtonItem(customView: serarchButton)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func menuButtonTapped() {
        //Menu Button Action
    }
    
    @objc func serarchButtonTapped() {
        //Search Button Action
    }
}

extension FoodCardsViewController: FoodCardsView {
    func initView() {
        
    }
}

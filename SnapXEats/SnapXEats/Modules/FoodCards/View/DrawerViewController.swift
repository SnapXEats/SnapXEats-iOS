//
//  HomeViewController.swift
//  Parkwel
//
//  Created   on 14/10/15.
//  Copyright © 2015 Saleel Karkhanis. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var navigationOptions = [SnapXEatsMenuOptions.wishlist, SnapXEatsMenuOptions.preferences, SnapXEatsMenuOptions.foodJourney, SnapXEatsMenuOptions.rewards]
    
    @IBOutlet weak var navigationOptionTable: UITableView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logoutButtonAction(sender: UIButton) {
        // Logout Button action
    }
    
    @IBAction func privacyPolicyButtonAction(sender: UIButton) {
        // Privacy Policy Action
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        registerNibsForCells()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userInfoView.addViewBorderWithColor(color: UIColor.rgba(230.0, 230.0, 230.0, 1.0), width: 1.0, side: .bottom)
        logoutButton.addViewBorderWithColor(color: UIColor.rgba(230.0, 230.0, 230.0, 1.0), width: 1.0, side: .top)
    }
    
    private func configureView() {
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.width/2
        navigationOptionTable.tableFooterView = UIView()
    }
    
    private func registerNibsForCells() {
        let nibName = UINib(nibName: SnapXEatsNibNames.navigationMenuTableViewCell, bundle:nil)
        navigationOptionTable.register(nibName, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.navigationMenu)
    }
    
    //MARK: TableViewDelegate & TableViewDatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navigationOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.navigationMenu, for: indexPath as IndexPath) as! NavigationMenuTableViewCell
        let showCount = indexPath.row == 0 ? true : false
        cell.configureCell(WithMenu: navigationOptions[indexPath.row], showCount: showCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            switch indexPath.row {
//            case 0: self.navigateToHomePage()
//            case 1: self.navigateToMenuOption(identifier: PCConstants.Identifiers.ourstoryNavigation)
//            case 2: self.navigateToMenuOption(identifier: PCConstants.Identifiers.clientdiariesNavigation)
//            case 3: self.navigateToMenuOption(identifier: PCConstants.Identifiers.policiesNavigation)
//            case 4: self.navigateToMenuOption(identifier: PCConstants.Identifiers.reachUsNavigation)
//            //case 5: self.showLogoutConfirmationAlert()
//            default:
//                break
//            }
    }
}

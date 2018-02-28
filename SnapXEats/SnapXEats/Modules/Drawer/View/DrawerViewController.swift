//
//  HomeViewController.swift
//  Parkwel
//
//  Created   on 14/10/15.
//  Copyright © 2015 Saleel Karkhanis. All rights reserved.
//

import UIKit
import AlamofireImage

class DrawerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var presenter: DrawerPresentation?
    
    let loginUserPreference = LoginUserPreferences.shared
    
    var navigationOptions = [SnapXEatsPageTitles.restaurants, SnapXEatsPageTitles.wishlist, SnapXEatsPageTitles.preferences, SnapXEatsPageTitles.foodJourney, SnapXEatsPageTitles.rewards]
    
    var screenIndex: Int = 0
    @IBOutlet weak var navigationOptionTable: UITableView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logoutButtonAction(sender: UIButton) {
        if loginUserPreference.isLoggedIn {
            let cancel = UIAlertAction(title: SnapXButtonTitle.cancel, style: UIAlertActionStyle.default, handler: nil)
            let Ok = UIAlertAction(title: SnapXButtonTitle.ok, style: UIAlertActionStyle.default, handler:  {[weak self] action in
                SnapXEatsLoginHelper.shared.resetData()
                self?.presenter?.presentScreen(screen: .login, drawerState: .closed)})
            UIAlertController.presentAlertInViewController(self, title: AlertTitle.logOutTitle , message: AlertMessage.logOutMessage, actions: [cancel, Ok], completion: nil)
        } else {
            SnapXEatsLoginHelper.shared.resetData()
            presenter?.presentScreen(screen: .login, drawerState: .closed)
        }
        
    }
    
    @IBAction func privacyPolicyButtonAction(sender: UIButton) {
        // Privacy Policy Action
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // To refresh the Wishlist Count on Evrytime Drawer loads
        navigationOptionTable.reloadData()
    }
    
    override func success(result: Any?) {
        if let _ = result as? Bool {
            loginUserPreference.isDirtyPreference = false
            presentScreen(index: screenIndex)
        }
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
        let text = loginUserPreference.isLoggedIn ? SnapXButtonTitle.loginOut : SnapXButtonTitle.loginIn
        logoutButton.setTitle(text, for: .normal)
        addUserInfo()
    }
    
    private func addUserInfo() {
        if let loginInfo =  SnapXEatsLoginHelper.shared.getloginInfo(), let url = URL(string: loginInfo.imageURL) {
            let placeholderImage = UIImage(named: SnapXEatsImageNames.profile_placeholder)!
            userImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
            userNameLabel.text = loginInfo.name
        }
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
        let showCount = indexPath.row == 1 ? true : false
        cell.configureCell(WithMenu: navigationOptions[indexPath.row], showCount: showCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if loginUserPreference.isDirtyPreference {
                showPreferenceSaveDialog(index: indexPath.row)
            } else {
                presentScreen(index: indexPath.row)
            }

    }
    
    private func presentScreen(index: Int) {
        switch index {
        case 0:
            presenter?.presentScreen(screen: .location, drawerState: .closed)
        case 2:
            presenter?.presentScreen(screen: .userPreference, drawerState: .closed)
        default:
            break
        }
    }
    
}

extension DrawerViewController: BaseView {
    func initView() {
        configureView()
        registerNibsForCells()
    }
    
    private func presentNextScreen(index: Int) {
        screenIndex = index
        
        if  loginUserPreference.isLoggedIn {
            if  checkRechability() {
                showLoading()
                loginUserPreference.firstTimeUser ? presenter?.sendUserPreference(preference: loginUserPreference)
                    : presenter?.updateUserPreference(preference: loginUserPreference)
            }
        }
        else {
            presentScreen(index: index)
        }
    }
    
    private func showPreferenceSaveDialog(index: Int) {
        let apply =  setApplyButton { [weak self] in
            self?.presentNextScreen(index: index)
        }
        
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.preferenceTitle , message: AlertMessage.preferenceMessage, actions: [apply], completion: nil)
    }
    
    
    private func setApplyButton(completionHandler: @escaping () ->()) -> UIAlertAction {
        return UIAlertAction(title: SnapXButtonTitle.apply, style: UIAlertActionStyle.default, handler:  {action in completionHandler()})
    }
}

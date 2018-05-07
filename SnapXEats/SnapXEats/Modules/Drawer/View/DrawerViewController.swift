//
//  HomeViewController.swift
//  Parkwel
//
//  Created   on 14/10/15.
//  Copyright © 2015 Saleel Karkhanis. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreLocation

enum navigateScreen: Int {
    case home = 0
    case wishList
    case showPreference
    case foodJourney
    // case rewards  add rewards later by uncomment it and add in option  the order should follow
    case snapnshare
    case smartPhotos
    case privacyPolicy
    case showLogin
}
class DrawerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var presenter: DrawerPresentation?
    
    let loginUserPreference = LoginUserPreferences.shared
    var navigationOptions = [SnapXEatsPageTitles.home, SnapXEatsPageTitles.wishlist, SnapXEatsPageTitles.preferences, SnapXEatsPageTitles.foodJourney, SnapXEatsPageTitles.snapnshare, SnapXEatsPageTitles.smartPhotos]
    
    var screenIndex: navigateScreen = .home
    var enableSmartPhoto: Bool {
        return  SmartPhotoHelper.shared.hasDraftPhotos() || SmartPhotoHelper.shared.hasSmartPhotos()
    }
    var isUserCheckedIn: Bool {
        if CheckInHelper.shared.isCheckedIn() {
            return true
        }
        return false
    }
    
    let userPreference = UserPreference()
    var currentView: UIViewController {
        get {
            return self
        }
    }
    
    @IBOutlet weak var navigationOptionTable: UITableView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nonLoggedInUserMessageLabel: UILabel!
    @IBOutlet weak var loggedInUserInfoView: UIView!
    
    @IBOutlet weak var checkInButton: UIButton!
    
    @IBAction func checkInAction(_ sender: Any) {
        if isUserCheckedIn == false {
            checkLocationStatus()
        } else {
            CheckInHelper.shared.checkOutUser()
            presenter?.presentScreen(screen: .location, drawerState: .closed)
        }
    }
    @IBAction func logoutButtonAction(sender: UIButton) {
        if loginUserPreference.isLoggedIn {
            let cancel = UIAlertAction(title: SnapXButtonTitle.cancel, style: UIAlertActionStyle.default, handler: nil)
            let Ok = UIAlertAction(title: SnapXButtonTitle.ok, style: UIAlertActionStyle.default, handler:  {[weak self] action in
                self?.screenIndex = .showLogin
                self?.showLoading()
                self?.presenter?.sendlogOutRequest()})
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
        CheckInHelper.shared.userCheckedOut()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CheckInHelper.shared.userCheckedOut()
        if isUserCheckedIn {
            checkInButton.setTitle(SnapXButtonTitle.checkOut, for: .normal)
        } else {
            checkInButton.setTitle(SnapXButtonTitle.checkIn, for: .normal)
        }
        // To refresh the Wishlist Count on Evrytime Drawer loads
        navigationOptionTable.reloadData()
    }
    
    override func success(result: Any?) {
        if let _ = result as? Bool {
            loginUserPreference.isDirty = false
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
        
        // Set up multicolor Message for Non Logged In User
        let nonLoggedInUserMessage = NSMutableAttributedString(string: SnapXNonLoggedInUserConstants.message)
        nonLoggedInUserMessage.setColorForText(SnapXNonLoggedInUserConstants.highlightText, with: UIColor.rgba(230.0, 118.0, 7.0, 1.0))
        nonLoggedInUserMessageLabel.attributedText = nonLoggedInUserMessage
        
        userImageView.image = UIImage(named: SnapXEatsImageNames.profile_placeholder)
        loginUserPreference.isLoggedIn ? configureLoggedInUserInfoView() : configureNonLoggedInUserInfoView()
    }
    
    private func configureNonLoggedInUserInfoView() {
        loggedInUserInfoView.isHidden = true
        nonLoggedInUserMessageLabel.isHidden = false
        logoutButton.setTitle(SnapXButtonTitle.loginIn, for: .normal)
    }
    
    private func configureLoggedInUserInfoView() {
        loggedInUserInfoView.isHidden = false
        nonLoggedInUserMessageLabel.isHidden = true
        logoutButton.setTitle(SnapXButtonTitle.loginOut, for: .normal)
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
        cell.loggedIn = loginUserPreference.isLoggedIn
        let showCount = indexPath.row == 1 ? true : false
        let title = navigationOptions[indexPath.row]
        if title == SnapXEatsPageTitles.smartPhotos {
            cell.enableSmartPhoto = enableSmartPhoto
        } else if title == SnapXEatsPageTitles.snapnshare {
            cell.isCheckedIn = isUserCheckedIn
        }
        cell.configureCell(WithMenu: title, showCount: showCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  screen = navigateScreen(rawValue: indexPath.row) ?? .home
        if loginUserPreference.isDirty {
            showPreferenceSaveDialog(screen: screen)
        } else {
            presentScreen(index: screen)
        }
    }
    
    private func presentScreen(index: navigateScreen) {
        switch index {
        case .home:
            presenter?.presentScreen(screen: .location, drawerState: .closed)
        case .wishList:
            loginUserPreference.isLoggedIn ? showWishListForLoggedInUser() : showWishlistForNonLoggedInUser()
        case .showPreference:
            presenter?.presentScreen(screen: .userPreference, drawerState: .closed)
        case .foodJourney:
            if loginUserPreference.isLoggedIn  {
                presenter?.presentScreen(screen: .foodJourney, drawerState: .closed)
            }
        case .snapnshare:
            if let restroID = CheckInHelper.shared.getCheckInRestroInfo() {
                let screenToPresent = Screens.snapNShareHome(restaurantID: restroID, displayFromNotification: true) // it should not show the reminder pop up again
                presenter?.presentScreen(screen: screenToPresent, drawerState: .closed)
            }
        case .smartPhotos:
            if enableSmartPhoto {
                presenter?.presentScreen(screen: .smartPhotoDraft, drawerState: .closed)
            }
        case .showLogin:
            presenter?.presentScreen(screen: .login, drawerState: .closed)
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
    
    private func presentNextScreen(index: navigateScreen) {
        screenIndex = index
        if  loginUserPreference.isLoggedIn {
            if  checkRechability() {
                showLoading()
                loginUserPreference.firstTimeUser ? presenter?.sendUserPreference(preference: loginUserPreference)
                    : presenter?.updateUserPreference(preference: loginUserPreference)
            }
        }
        else {
            loginUserPreference.isDirty = false
            presentScreen(index: index)
        }
    }
    
    private func showPreferenceSaveDialog(screen: navigateScreen) {
        let apply =  setApplyButton { [weak self] in
            self?.presentNextScreen(index: screen)
        }
        
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.preferenceTitle , message: AlertMessage.preferenceMessage, actions: [apply], completion: nil)
    }
    
    private func setApplyButton(completionHandler: @escaping () ->()) -> UIAlertAction {
        return UIAlertAction(title: SnapXButtonTitle.apply, style: UIAlertActionStyle.default, handler:  {action in completionHandler()})
    }
    
    private func showWishListForLoggedInUser() {
        if let count = presenter?.wishListCount(), count > 0 {
            presenter?.presentScreen(screen: .wishlist, drawerState: .closed)
        }
    }
    
    private func showWishlistForNonLoggedInUser() {
        let okAction = UIAlertAction(title: SnapXButtonTitle.ok, style: .default, handler: nil)
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.wishlist, message: AlertMessage.wishlistForNonLoggedinUser, actions: [okAction], completion: nil)
    }
}


extension DrawerViewController: CLLocationManagerDelegate, SnapXEatsUserLocation {
    
    //TODO: Use Common Location related functionality from SnapXEatsUserLocation. It will be used to show settings popup if user has denied permission for Location and other use cases.
    func checkLocationStatus() {
        let status = CLLocationManager.authorizationStatus()
        switch status  {
        case .authorizedWhenInUse, .authorizedAlways:
               // Don't check network here because of LocationViewController viewWillPresent get call before popup show and it shows
                // network error for cuiselist
               presenter?.presentScreen(screen: .checkin(restaurant: nil), drawerState: .closed)
        case .denied:
                showSettingDialog()
        case  .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           // We not need to handle delegate here, we are just checking location is enable or not before checkin
    }
}

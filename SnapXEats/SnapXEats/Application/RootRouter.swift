
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftInstagram
import UserNotifications

enum Screens {
    case firsTimeUser, login, instagram(sharedLoginFromSkip: Bool, rootController: UINavigationController?), location, firstScreen, foodcards(selectPreference: SelectedPreference, parentController: UINavigationController), selectLocation(parent: UIViewController), userPreference, foodAndCusinePreferences(preferenceType: PreferenceType, parentController: UINavigationController), restaurantDetails(restaurantID: String, parentController: UINavigationController, showMoreInfo: Bool), restaurantDirections(details: RestaurantDetails, parentController: UINavigationController), wishlist, restaurantsMapView(restaurants: [Restaurant], parentController: UINavigationController), snapNShareHome(restaurantID: String, displayFromNotification: Bool), snapNSharePhoto(photo: UIImage, iparentController: UINavigationController, restaurantDetails: RestaurantDetails?), snapNShareSocialMedia(smartPhoto_Draft_Stored_id: String?, parentController: UINavigationController), checkin(restaurant: CheckInRestaurant?),
    sharedSuccess(restaurantID: String), loginPopUp(storedID: String, parentController: UINavigationController, loadFromSmartPhot_Draft: Bool), socialLoginFromLoginPopUp(smartPhoto_Draft_Stored_id: String?, parentController: UINavigationController), smartPhoto(smartPhoto_Draft_Stored_id: String?, dishID: String, type: SmartPhotoType, parentController: UINavigationController?), smartPhotoDraft, foodJourney, snapAndShareFromDraft(smartPhoto_Draft_Stored_id: String?, parentController: UINavigationController), reminderPopUp(rewardsPoint: Int, restaurantID: String?, delegate: CameraMode)
}

class RootRouter: NSObject {
    private var window: UIWindow? {
        guard let window  = UIApplication.shared.delegate?.window! else { return nil }
        return window
    }
    private var drawerController: KYDrawerController!
    
    fileprivate var reminderCount : Int {
        set {
            UserDefaults.standard.set(newValue, forKey: NotificationConstant.requestIdentifier)
        }
        get {
            return UserDefaults.standard.integer(forKey: NotificationConstant.requestIdentifier)
        }
    }
    private override init() {
    }
    
    static var shared = RootRouter()
    
    func presentFirstScreen(inWindow window: UIWindow) {
        userLoggedIn()
    }
    
    private func presentFirstTimeUserScreen() {
        showFirstScreen()
    }
    
    private func userLoggedIn() {
        if faceBookLoggedIn() || instagramLoggedIn() {
            showFirstScreen()
        } else {
            presentLoginScreen()
        }
    }
    
    private func showFirstScreen() {
        SnapXEatsLoginHelper.shared.firstTimeUser()
            ? presentScreen(screens: .userPreference)
            : presentScreen(screens: .location)
    }
    
    private func instagramLoggedIn () -> Bool{
        return UserDefaults.standard.bool(forKey: InstagramConstant.INSTAGRAM_LOGGEDIN)
    }
    
    private func faceBookLoggedIn () -> Bool {
        return SnapXEatsLoginHelper.shared.fbHelper()
    }
    
    private func presentFirstScreen() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func presentLoginScreen() {
        let loginViewController = LoginRouter.singletenInstance.loadLoginModule() as! LoginViewController
        presentView(loginViewController)
    }
    
    private func presentLoginInstagramScreen(sharedLoginFromSkip: Bool, parentController: UINavigationController?) {
        let  instagramViewController = InstagramLoginRouter.shared.loadInstagramView() as! InstagramLoginViewController
        instagramViewController.sharedLoginFromSkip = sharedLoginFromSkip
        instagramViewController.parentController = parentController
        if sharedLoginFromSkip {
            window?.rootViewController?.dismiss(animated: false, completion: nil) // first dissmiss the  login  with FB and Instagram view when user try to shared photo 
        }
        window?.rootViewController?.present(instagramViewController, animated: true, completion: nil)
    }
    
    private func presentLocationScreen() {
        //let locatioViewController = LocationRouter.singleInstance.loadLocationModule() as! LocationViewController
        
        let locationNavigationController = LocationRouter.singleInstance.loadLocationModule()
        updateDrawerWithMainController(mainVC: locationNavigationController)
        presentView(drawerController)
    }
    
    private func pushFoodcardsScreen(selectedPreference: SelectedPreference, onNavigationController parentController: UINavigationController) {
        
        let foodCardVC = FoodCardsRouter.shared.loadFoodCardModule()
        foodCardVC.selectedPrefernce = selectedPreference
        parentController.pushViewController(foodCardVC, animated: true)
    }
    
    private func pushFoodAndCuisinePreferencesScreen(onNavigationController parentController: UINavigationController, withPreferenceType type: PreferenceType) {
        
        let foodCardVC = FoodAndCuisinePreferenceRouter.shared.loadFoodAndCuisinePreferenceModule()
        foodCardVC.preferenceType = type
        parentController.pushViewController(foodCardVC, animated: true)
    }
    
    private func presentUserPreferencesScreen() {
        let userPreferenceNvController = UserPreferenceRouter.shared.loadUserPreferenceModule()
        updateDrawerWithMainController(mainVC: userPreferenceNvController)
        presentView(drawerController)
    }
    
    private func presentWishlistScreen() {
        let wishlistNvController = WishlistRouter.shared.loadWishlistModule()
        updateDrawerWithMainController(mainVC: wishlistNvController)
        presentView(drawerController)
    }
    
    private func pushRestaurantsMapView(onNavigationController parentController: UINavigationController, withRestaurants restaurants: [Restaurant]) {
        let restaurantMapsVC = RestaurantsMapViewRouter.shared.loadRestaurantsMapViewModule()
        restaurantMapsVC.restaurants = restaurants
        parentController.pushViewController(restaurantMapsVC, animated: true)
    }
    
    private func presentSnapNShareHomeScreen(restaurantID: String, displayFromNotification: Bool) {
        let snapNShareHomeNavigation = SnapNShareHomeRouter.shared.loadSnapNShareHomeModule()
        if let snapNShareHomeVC = snapNShareHomeNavigation.viewControllers.first as? SnapNShareHomeViewController{
            snapNShareHomeVC.restaurantID = restaurantID
            snapNShareHomeVC.displayFromNotification = displayFromNotification
        }
        
        updateDrawerWithMainController(mainVC: snapNShareHomeNavigation)
        presentView(drawerController)
    }
    
    private func presentCheckinPopupForRestaurant(restaurant: CheckInRestaurant?) {
        if let window = UIApplication.shared.keyWindow, SnapXEatsNetworkManager.shared.isConnectedToInternet == true {
            let checkinPopup = CheckinPopupRouter.shared.loadCheckinPopupModule()
            checkinPopup.checkinPopupDelegate = RootRouter.shared
            checkinPopup.restaurant = restaurant
            let popupFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            checkinPopup.setupPopup(frame: popupFrame, restaurant: restaurant)
            window.addSubview(checkinPopup)
        }
    }
    
    private func dissmissSelectLocationScreen() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func presentSelectLocationScreen(parent: UIViewController) {
        let selectLocationViewController = SelectLocationRouter.singleInstance.loadSelectLocationModule()
        parent.present(selectLocationViewController, animated: true, completion: nil)
    }
    
    private func pushRestaurantDetailsScreen(onNavigationController parentController: UINavigationController, forRestaurant restaurantID: String, showMoreInfo: Bool) {
        let restaurantDetailsVC = RestaurantDetailsRouter.shared.loadRestaurantDetailsModule()
        restaurantDetailsVC.restaurant_info_id = restaurantID
        restaurantDetailsVC.showMoreInfo = showMoreInfo
        parentController.pushViewController(restaurantDetailsVC, animated: true)
    }
    
    private func pushRestaurantDirectionsScreen(onNavigationController parentController: UINavigationController, withDetails details: RestaurantDetails) {
        let restaurantDetailsVC = RestaurantDirectionsRouter.shared.loadRestaurantDirectionsModule()
        restaurantDetailsVC.restaurantDetails = details
        parentController.pushViewController(restaurantDetailsVC, animated: true)
    }
    
    private func pushSnapNSharePhotoScreen(onNavigationController parentController: UINavigationController, withPhoto photo: UIImage, restaurantDetails: RestaurantDetails?) {
        let snapNSharePhotoVC = SnapNSharePhotoRouter.shared.loadSnapNSharePhotoModule()
        snapNSharePhotoVC.snapPhoto = photo
        snapNSharePhotoVC.restaurantDetails = restaurantDetails
        parentController.pushViewController(snapNSharePhotoVC, animated: true)
    }
    
    private func pushSnapNShareSocialMediaScreen(smartPhoto_Draft_Stored_id: String?, onNavigationController parentController: UINavigationController) {
        let snapNShareSocialMediaVC = SnapNShareSocialMediaRouter.shared.loadSnapNshareSocialMediaModule()
        snapNShareSocialMediaVC.smartPhoto_Draft_Stored_id = smartPhoto_Draft_Stored_id
        parentController.pushViewController(snapNShareSocialMediaVC, animated: true)
    }
    
    private func presentSocialShareAferNewLogin(smartPhoto_Draft_Stored_id: String?, parentController: UINavigationController) {
        showSocialMediaScreenAfterPopUp(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: parentController)
    }
    
    private func presentSocialShareFromDraft(smartPhoto_Draft_Stored_id: String?, parentController: UINavigationController) {
        showSocialMediaScreenAfterPopUp(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: parentController)
    }
    
    private func showSocialMediaScreenAfterPopUp(smartPhoto_Draft_Stored_id: String?, parentController: UINavigationController) {
        let drawerVC = DrawerRouter.shared.loadDrawerMenu()
        drawerController.drawerViewController = drawerVC
        window?.rootViewController?.dismiss(animated: true, completion: nil)
        pushSnapNShareSocialMediaScreen(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, onNavigationController: parentController)
    }
    
    private func presentLoginPopUp(smartPhoto_Draft_Stored_id: String?, parentController: UINavigationController, loadFrom_SmartPhot_Draft: Bool) {
        let viewController = LoginPopUpRouter.shared.loadLoginPopUpView()
        viewController.smartPhoto_Draft_Stored_id = smartPhoto_Draft_Stored_id
        viewController.rootController = parentController
        viewController.loadFromSmartPhot_DraftScreen = loadFrom_SmartPhot_Draft
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func updateDrawerState(state: KYDrawerController.DrawerState) {
        drawerController.setDrawerState(state, animated: true)
    }
    
    func presentScreen(screen: Screens, drawerState: KYDrawerController.DrawerState) {
        drawerController.setDrawerState(drawerState, animated: true)
        presentScreen(screens: screen)
    }
    
    func presentSmartPhotoScreen(smartPhoto_Draft_Stored_id: String?, dishID: String, type: SmartPhotoType, parentController: UINavigationController?) {
        let smartPhotoController = SmartPhotoRouter.shared.loadModule()
        smartPhotoController.dishID = dishID
        smartPhotoController.smartPhoto_Draft_Stored_id = smartPhoto_Draft_Stored_id
        smartPhotoController.photoType = type
        smartPhotoController.parentController = parentController
        window?.rootViewController?.present(smartPhotoController, animated: true, completion: nil)
    }
    
    func presentSmartPhotoDraft() {
        let smartPhotoDraftVC = SmartPhotoDraftRouter.shared.loadSmartPhotoDraftModule()
        updateDrawerWithMainController(mainVC: smartPhotoDraftVC)
        presentView(drawerController)
    }
    
    func presentFoodJourney() {
        let foodJourney = FoodJourneyRouter.shared.loadFoodJoureyModule()
        updateDrawerWithMainController(mainVC: foodJourney)
        presentView(drawerController)
    }
    
    func loadReminderPopup() -> ReminderPopUp {
        let reminderPopUp = UINib(nibName:SnapXEatsNibNames.reminderPopUp, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ReminderPopUp
        return reminderPopUp
    }
    
    func showReminderView(rewardPoints: Int, restaurantID: String?, delegate: CameraMode) {
        let reminderview = loadReminderPopup()
        if let frame = window?.rootViewController?.view.frame {
            reminderview.setupPopup(frame, rewardPoints: rewardPoints)
        }
        reminderview.restaurantID = restaurantID
        reminderview.cameraDelegate = delegate
        reminderview.notificationDelegate = RootRouter.shared
        window?.rootViewController?.view.addSubview(reminderview)
    }
    
    func presentSuccessDialog() {
        if let controller =  window?.rootViewController {
            let okAction = UIAlertAction(title: SnapXButtonTitle.ok, style: .default, handler: { [weak self] action in
                self?.presentFirstTimeUserScreen()
            })
        UIAlertController.presentAlertInViewController(controller, title: AlertTitle.loginSuccess, message: AlertMessage.loginSuccessMessage, actions: [okAction], completion: nil)
        }
    }
    
    func presentScreen(screens: Screens) {
        
        if window?.rootViewController == nil &&  drawerController != nil {
            presentView(drawerController)  // some tim the rootViewController become nil
        }
        
        switch screens {
        case .firsTimeUser:
                presentSuccessDialog()
        case .firstScreen:
            presentFirstScreen()
        case .login:
            presentLoginScreen()
        case .instagram(let sharedLoginFromSkip, let parentController):
            presentLoginInstagramScreen(sharedLoginFromSkip: sharedLoginFromSkip, parentController: parentController)
        case .location:
            presentLocationScreen()
        case .foodcards(let selectedPreference, let parentController):
            pushFoodcardsScreen(selectedPreference: selectedPreference, onNavigationController: parentController)
        case .selectLocation(let  viewController):
            presentSelectLocationScreen(parent: viewController)
        case .userPreference:
            presentUserPreferencesScreen()
        case .foodAndCusinePreferences(let preferenceType, let parentController):
            pushFoodAndCuisinePreferencesScreen(onNavigationController: parentController, withPreferenceType: preferenceType)
        case .restaurantDetails(let restaurantID, let parentController, let showMoreInfo):
            pushRestaurantDetailsScreen(onNavigationController: parentController, forRestaurant: restaurantID, showMoreInfo: showMoreInfo)
        case .restaurantDirections(let details, let parentController):
            pushRestaurantDirectionsScreen(onNavigationController: parentController, withDetails: details)
        case .wishlist:
            presentWishlistScreen()
        case .restaurantsMapView(let restaurants, let parentController):
            pushRestaurantsMapView(onNavigationController: parentController, withRestaurants: restaurants)
        case .snapNShareHome(let restaurantid, let displayFromNotification):
            presentSnapNShareHomeScreen(restaurantID: restaurantid, displayFromNotification: displayFromNotification)
        case .checkin(let restaurant):
            presentCheckinPopupForRestaurant(restaurant: restaurant)
        case .snapNSharePhoto(let photo, let parentController, let reataurantDetails):
            pushSnapNSharePhotoScreen(onNavigationController: parentController, withPhoto: photo, restaurantDetails: reataurantDetails)
        case .snapNShareSocialMedia(let smartPhoto_Draft_Stored_id, let parentController):
            pushSnapNShareSocialMediaScreen(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, onNavigationController: parentController)
        case .sharedSuccess(let restaurantID):
            presentSuccessFulSharedPhoto(restaurantID: restaurantID)
        case .loginPopUp(let smartPhoto_Draft_Stored_id, let parentController, let loadFrom_SmartPhot_Draft):
            presentLoginPopUp(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: parentController, loadFrom_SmartPhot_Draft: loadFrom_SmartPhot_Draft)
        case .socialLoginFromLoginPopUp(let smartPhoto_Draft_Stored_id,let parentController):
            presentSocialShareAferNewLogin( smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: parentController)
        case .smartPhoto(let smartPhoto_Draft_Stored_id, let dishID, let type, let parent):
            presentSmartPhotoScreen(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, dishID: dishID, type: type, parentController: parent)
        case .smartPhotoDraft:
            presentSmartPhotoDraft()
        case .foodJourney:
            presentFoodJourney()
        case .snapAndShareFromDraft(let smartPhoto_Draft_Stored_id, let parentController):
            presentSocialShareFromDraft(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: parentController)
        case .reminderPopUp(let rewardsPoint, let restaurantID, let cameraDelegate):
            showReminderView(rewardPoints: rewardsPoint, restaurantID: restaurantID, delegate: cameraDelegate)
        }
    }
    
    private func presentView(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.delegate?.window! else { return }
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        window.rootViewController = viewController
    }
    
    private func updateDrawerWithMainController(mainVC: UINavigationController) {
        drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: (0.61 * UIScreen.main.bounds.width))
        let drawerVC = DrawerRouter.shared.loadDrawerMenu()
        drawerController.mainViewController = mainVC
        drawerController.drawerViewController = drawerVC
    }
}

extension RootRouter: CheckinPopUpActionsDelegate {
    func userDidChekintoRestaurant(restaurantID: String) {
        //SnapXEatsLoginHelper.shared.checkinUser()
        presentScreen(screen: .snapNShareHome(restaurantID: restaurantID, displayFromNotification: false), drawerState: .closed)
    }
}

extension RootRouter: SharedSucceesActionsDelegate {
    func movetoSnapNShareScreen(restaurantID: String) {
        presentScreen(screen: .snapNShareHome(restaurantID: restaurantID, displayFromNotification: false), drawerState: .closed)
    }
    
    func popupDidDismiss() {
        presentScreen(screens: .location)
    }
    
    
    private func presentSuccessFulSharedPhoto(restaurantID: String) {
        if let window = UIApplication.shared.keyWindow {
            let sharedSucceesPopup = SnapNShareSocialMediaRouter.shared.loadSharedSuccessPopup()
            sharedSucceesPopup.restaurantID = restaurantID
            sharedSucceesPopup.sharedSuccessDelegate = RootRouter.shared
            let popupFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            sharedSucceesPopup.setupPopup(popupFrame, rewardPoints: 0)
            window.addSubview(sharedSucceesPopup)
        }
    }
    
}

@available(iOS 10.0, *)
extension RootRouter: ReminderNotification {
    
    func regiterNotification(restaurantID: String) {
        SnapXNotificataionHelper.shared.registerReminderNotification(restaurantID: restaurantID)
    }
    
    func checkNotificationIdentifier(notification: UNNotification, completionHandler: (UNNotificationPresentationOptions) -> Void) {
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        //        if  notification.request.identifier == NotificationConstant.requestIdentifier {
        //        }
        completionHandler([.alert, .badge, .sound])
    }
    
    func checkNotification(response: UNNotificationResponse, completionHandler: () -> Void) {
        switch response.actionIdentifier {
        case NotificationConstant.remindLater:
            if let restaurentID = response.notification.request.content.userInfo[SnapXEatsConstant.restaurantID] as? String {
                SnapXNotificataionHelper.shared.registerReminderNotification(restaurantID: restaurentID)
            }
            completionHandler()
        case NotificationConstant.takePhoto:
            if  let drawerController = window?.rootViewController as? KYDrawerController, let navigationController = drawerController.mainViewController as? UINavigationController {
                let filterController = navigationController.viewControllers.filter({ (viewController) -> Bool in
                    if let _ = viewController as? SnapNShareHomeViewController {
                        return true
                    }
                    return false
                })
                if filterController.count == 1 {
                    return
                }else {
                    presentSnapNShare(content: response.notification.request.content)
                    SnapXNotificataionHelper.shared.removeDeliveredNotification(requestIdentifier: NotificationConstant.requestIdentifier)
                }
                
                completionHandler()
            }
        default:
            if response.notification.request.identifier == NotificationConstant.chekINrequestIdentifier {
                
                BackgroundLocationHelper.shared.reset()
                let userinfo = response.notification.request.content.userInfo
                let checkInrestaurant = SnapXNotificataionHelper.shared.createRestaurantData(userInfo: userinfo)
                if let restaurant = checkInrestaurant {
                    presentCheckinPopupForRestaurant(restaurant: restaurant)
                }
            } else {
                presentSnapNShare(content: response.notification.request.content)
                SnapXNotificataionHelper.shared.removeDeliveredNotification(requestIdentifier: NotificationConstant.requestIdentifier)
            }
        }
    }
    
    func presentSnapNShare(content: UNNotificationContent) {
        if let restaurentID = content.userInfo[SnapXEatsConstant.restaurantID] as? String {
            presentScreen(screens: .snapNShareHome(restaurantID: restaurentID, displayFromNotification: true))
        }
    }
}

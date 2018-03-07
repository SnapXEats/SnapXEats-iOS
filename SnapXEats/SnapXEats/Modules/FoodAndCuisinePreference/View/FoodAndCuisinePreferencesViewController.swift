//
//  CuisinePreferencesViewController.swift
//  SnapXEats
//
//  Created by synerzip on 13/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import RealmSwift

class FoodAndCuisinePreferencesViewController: BaseViewController, StoryboardLoadable {
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 30.0, right: 20.0)
    
    @IBOutlet weak var resetButton: UIButton!
    var preferenceType: PreferenceType!
    var presenter: FoodAndCuisinePreferencePresentation?
    var preferenceItems = [PreferenceItem]()
    let loginUserPreferences = LoginUserPreferences.shared
    var isDirtyPreferecne : Bool = false {
        willSet {
            if preferenceType == .cuisine  {
                loginUserPreferences.isDirtyCuisinePreference = newValue
            } else {
                loginUserPreferences.isDirtyFoodPreference = newValue
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = newValue
        }
    }
    
    @IBOutlet weak var preferencesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        isDirtyPreferecne = false 
    }
    
    override func internetConnected() {
        if preferenceItems.count == 0 {
            getPreferences()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPreferences()
    }
    
    override func success(result: Any?) {
        if let result = result as? FoodPreference {
            preferenceItems = result.foodItems
            getSavedPreferecne()
        } else if let result = result as? CuisinePreference {
            preferenceItems = result.cuisineList
            getSavedPreferecne()
        } else if let result = result as? Bool, result == true {
            hideLoading()
            enableRest()
            preferencesCollectionView.reloadData()
        }
    }
    
    @IBAction func doneButtonAction(_: Any) {
        savePreference()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func savePreference() {
        if loginUserPreferences.isLoggedIn && isDirtyPreferecne {
            presenter?.savePreferecne(type: preferenceType, usierID: loginUserPreferences.loginUserID, preferencesItems: preferenceItems)
        } else {
            savePrefernceData()
        }
    }
    
    private func enableBackButtonAction() {
        let newBackButton = UIBarButtonItem(image: UIImage(named: SnapXEatsImageNames.backArrow), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    // Then handle the button selection
    @objc func backAction() {
        if  isDirtyPreferecne { showPreferenceIsDirtyDialog() }
        else { self.navigationController?.popViewController(animated: true) }
    }
    
    private func showPreferenceIsDirtyDialog() {
        let ok =  setOkButton(title: SnapXButtonTitle.save) { [weak self] in
             self?.savePreference()
            self?.navigationController?.popViewController(animated: true)
        }
        let cancel = setCancelButton { [weak self] in
            self?.isDirtyPreferecne = false
            self?.navigationController?.popViewController(animated: true)
        }
        
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.error , message: AlertMessage.preferenceSaveMessage, actions: [cancel, ok], completion: nil)
    }
    
    private func getSavedPreferecne() {
        if loginUserPreferences.isLoggedIn {
            presenter?.getSavedPreferecne(usierID: loginUserPreferences.loginUserID, type: preferenceType, preferenceItems: preferenceItems)
        } else {
            hideLoading()
            loadPrefernceData()
            preferencesCollectionView.reloadData()
        }
    }
    @IBAction func resetButtonAction(_: Any) {
        showPreferenceResetDialog()
    }
    
    private func enableRest()  {
        var state = false
        for item in preferenceItems {
            if item.isLiked || item.isFavourite {
                state = true
                break
            }
        }
        resetButton.isUserInteractionEnabled = state
        resetButton.alpha = state == true ? 1.0 : 0.5
    }
    
    private func resetPreferecne() {
        for item in preferenceItems {
            item.isFavourite = false
            item.isLiked = false
        }
        loginUserPreferences.isLoggedIn ? resetLoggedInUserData() : resetNonLoggedInUserData()
        preferencesCollectionView.reloadData()
        enableRest()
    }
    private func showPreferenceResetDialog() {
        let ok =  setOkButton(title: SnapXButtonTitle.ok) { [weak self] in
            self?.resetPreferecne()
            self?.isDirtyPreferecne = true
        }
        let cancel = setCancelButton {}
        
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.error , message: AlertMessage.preferecneRestMessage, actions: [cancel, ok], completion: nil)
    }
    
    private func setCancelButton(completionHandler: @escaping () ->()) -> UIAlertAction {
        return UIAlertAction(title: SnapXButtonTitle.cancel, style: UIAlertActionStyle.default, handler: {action in completionHandler()})
        
    }
    
    private func setOkButton(title: String, completionHandler: @escaping () ->()) -> UIAlertAction {
        return UIAlertAction(title: title, style: UIAlertActionStyle.default, handler:  {action in completionHandler()})
    }
    
    private func resetLoggedInUserData() {
        isDirtyPreferecne = true
        presenter?.resetData(type: preferenceType)
    }
    
    private func resetNonLoggedInUserData() {
        isDirtyPreferecne = true
        preferenceType == .cuisine ? loginUserPreferences.cuisinePreference.removeAll()
            : loginUserPreferences.foodPreference.removeAll()
    }
    
    private func getPreferences() {
        showLoading()
        presenter?.preferenceItemRequest(preferenceType: preferenceType)
    }
    
    private func loadPrefernceData() {
        if preferenceItems.count > 0 {
            preferenceType == .cuisine ? loadCuisineData() : loadFoodData()
        }
    }
    
    private func savePrefernceData() {
        if preferenceItems.count > 0 && isDirtyPreferecne {
            preferenceType == .cuisine ? updateCuisineData() : updateFoodData()
        }
    }
    
    private func loadCuisineData() {
        for cuisineData in loginUserPreferences.cuisinePreference {
            _ = preferenceItems.filter({ (preference) -> Bool in
                if cuisineData.itemID == preference.itemID && (cuisineData.isLiked || cuisineData.isFavourite) {
                    preference.isLiked = cuisineData.isLiked
                    preference.isFavourite = cuisineData.isFavourite
                    return true
                }
                return false
            })
        }
    }
    
    private func loadFoodData() {
        for foodData in loginUserPreferences.foodPreference {
            _ = preferenceItems.filter({ (preference) -> Bool in
                if foodData.itemID == preference.itemID && (foodData.isLiked || foodData.isFavourite) {
                    preference.isLiked = foodData.isLiked
                    preference.isFavourite = foodData.isFavourite
                    return true
                }
                return false
            })
        }
    }
    
    private func updateFoodData() {
        if isDirtyPreferecne {
                loginUserPreferences.foodPreference.removeAll()
                saveFoodData() //This is for first time user after skip
        }
    }
    
    private func saveFoodData() {
        for preference in preferenceItems {
            if let Id = preference.itemID, preference.isLiked || preference.isFavourite {
                let foodItem = FoodItem()
                foodItem.itemID = Id
                foodItem.isLiked = preference.isLiked
                foodItem.isFavourite = preference.isFavourite
                loginUserPreferences.foodPreference.append(foodItem)
            }
        }
    }
    
    private func updateCuisineData() {
        if isDirtyPreferecne {
                loginUserPreferences.cuisinePreference.removeAll()
                saveCuisineData() //This is for first time user after skip
            }
    }
    
    private func saveCuisineData() {
        for preference in preferenceItems {
            if let Id = preference.itemID, preference.isLiked || preference.isFavourite {
                let cuisineItem = CuisineItem()
                cuisineItem.itemID = Id
                cuisineItem.isLiked = preference.isLiked
                cuisineItem.isFavourite = preference.isFavourite
                loginUserPreferences.cuisinePreference.append(cuisineItem)
            }
        }
    }
}

extension FoodAndCuisinePreferencesViewController: FoodAndCuisinePreferenceView {
    func initView() {
        let pageTitle = (preferenceType == .food) ? SnapXEatsPageTitles.foodPreferences : SnapXEatsPageTitles.cusinePreferences
        customizeNavigationItem(title: pageTitle, isDetailPage: true)
        registerCellForNib()
        addGestureRecognizersForCollectionView()
        enableBackButtonAction()
        enableRest()
    }
    
    private func registerCellForNib() {
        let nib = UINib(nibName: SnapXEatsNibNames.preferenceTypeCollectionViewCell, bundle: nil)
        preferencesCollectionView.register(nib, forCellWithReuseIdentifier: SnapXEatsCellResourceIdentifiler.preferenceType)
    }
    
    private func addGestureRecognizersForCollectionView() {
        // Double Tap Gesture
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.cancelsTouchesInView = false
        preferencesCollectionView.addGestureRecognizer(doubleTapGesture)
        
        // Single Tap Gesture
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSingleTapCollectionView(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        preferencesCollectionView.addGestureRecognizer(singleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    // Gesture Action Methods
    @objc func didSingleTapCollectionView(_ sender: UITapGestureRecognizer) {
        let pointInCollectionView: CGPoint = sender.location(in: preferencesCollectionView)
        if let selectedIndexPath = preferencesCollectionView.indexPathForItem(at: pointInCollectionView) {
            
            let item = preferenceItems[selectedIndexPath.row]
            if !item.isFavourite { // If already Favourite Should not go back to Like
                item.isLiked = true
                item.isFavourite = false
                preferenceItems[selectedIndexPath.row] = item
                enableRest()
                isDirtyPreferecne = true
                preferencesCollectionView.reloadItems(at: [selectedIndexPath])
                
                
            }
        }
    }
    
    @objc func didDoubleTapCollectionView(_ sender: UITapGestureRecognizer) {
        let pointInCollectionView: CGPoint = sender.location(in: preferencesCollectionView)
        if let selectedIndexPath = preferencesCollectionView.indexPathForItem(at: pointInCollectionView) {
            
            let item = preferenceItems[selectedIndexPath.row]
            item.isLiked = false
            item.isFavourite = true
            preferenceItems[selectedIndexPath.row] = item
            isDirtyPreferecne = true
            enableRest()
            preferencesCollectionView.reloadItems(at: [selectedIndexPath])
            
        }
    }
}

extension FoodAndCuisinePreferencesViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preferenceItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnapXEatsCellResourceIdentifiler.preferenceType, for: indexPath) as! PreferenceTypeCollectionViewCell
        cell.configurePreferenceItemCell(preferenceItem: preferenceItems[indexPath.row], preferencetype: preferenceType)
        cell.preferenceItemStatusButton.tag = indexPath.row
        cell.preferenceItemStatusButton.addTarget(self, action: #selector(preferenceItemStatusButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func preferenceItemStatusButtonAction(_ button: UIButton) {
        let indexPath = IndexPath(item: button.tag, section: 0)
        let item = preferenceItems[button.tag]
        item.isLiked = false
        item.isFavourite = false
        isDirtyPreferecne = true
        preferenceItems[button.tag] = item
        enableRest()
        preferencesCollectionView.reloadItems(at: [indexPath])
    }
}

extension FoodAndCuisinePreferencesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace: CGFloat = 5 + sectionInsets.left * 2
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 2/3 + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
}

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
    
    var preferenceType: PreferenceType!
    var presenter: FoodAndCuisinePreferencePresentation?
    var preferenceItems = [PreferenceItem]()
    let selectedPrefernce = SelectedPreference.shared
    
    @IBOutlet weak var preferencesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
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
             preferencesCollectionView.reloadData()
        }
        
    }
    
    @IBAction func doneButtonAction(_: Any) {
        savePreference()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func savePreference() {
        presenter?.savePreferecne(type: preferenceType, usierID: selectedPrefernce.loginUserID, preferencesItems: preferenceItems)
    }
    
    private func getSavedPreferecne() {
        presenter?.getSavedPreferecne(usierID: selectedPrefernce.loginUserID, type: preferenceType, preferenceItems: preferenceItems)
    }
    @IBAction func resetButtonAction(_: Any) {
        for item in preferenceItems {
            item.isFavourite = false
            item.isLiked = false
        }
        preferencesCollectionView.reloadData()
    }
    
    private func getPreferences() {
        showLoading()
        presenter?.preferenceItemRequest(preferenceType: preferenceType)
    }
}

extension FoodAndCuisinePreferencesViewController: FoodAndCuisinePreferenceView {
    func initView() {
        let pageTitle = (preferenceType == .food) ? SnapXEatsPageTitles.foodPreferences : SnapXEatsPageTitles.cusinePreferences
        customizeNavigationItem(title: pageTitle, isDetailPage: true)
        registerCellForNib()
        addGestureRecognizersForCollectionView()
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
        preferenceItems[button.tag] = item
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

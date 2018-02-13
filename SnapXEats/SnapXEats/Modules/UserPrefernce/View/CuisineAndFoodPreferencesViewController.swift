//
//  CuisinePreferencesViewController.swift
//  SnapXEats
//
//  Created by synerzip on 13/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit

class CuisineAndFoodPreferencesViewController: BaseViewController, StoryboardLoadable {

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 30.0, right: 20.0)
    
    var preferenceType: PreferenceType!
    var presenter: UserPreferencePresentation?
    var preferenceItems = [PreferenceItem]()
    var selectedCuisineIndexes = NSMutableArray()
    
    @IBOutlet weak var preferencesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    @IBAction func saveButtonAction(_: Any) {
        
    }
}

extension CuisineAndFoodPreferencesViewController: UserPreferenceView {
    func initView() {
        let pageTitle = (preferenceType == .food) ? SnapXEatsPageTitles.foodPreferences : SnapXEatsPageTitles.cusinePreferences
        customizeNavigationItem(title: pageTitle, isDetailPage: true)
        registerCellForNib()
    }
    
    func registerCellForNib() {
        let nib = UINib(nibName: SnapXEatsNibNames.preferenceTypeCollectionViewCell, bundle: nil)
        preferencesCollectionView.register(nib, forCellWithReuseIdentifier: SnapXEatsCellResourceIdentifiler.preferenceType)
    }
}

extension CuisineAndFoodPreferencesViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preferenceItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnapXEatsCellResourceIdentifiler.preferenceType, for: indexPath) as! PreferenceTypeCollectionViewCell
        let isItemSelected = selectedCuisineIndexes.contains(indexPath.row) ? true : false
        cell.configurePreferenceItemCell(preferenceItem: preferenceItems[indexPath.row], preferencetype: preferenceType, isSelected: isItemSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCuisineIndexes.contains(indexPath.row) {
            selectedCuisineIndexes.remove(indexPath.row)
        } else {
            selectedCuisineIndexes.add(indexPath.row)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}

extension CuisineAndFoodPreferencesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace: CGFloat = 12 + sectionInsets.left * 2
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 2/3 + 42)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
}

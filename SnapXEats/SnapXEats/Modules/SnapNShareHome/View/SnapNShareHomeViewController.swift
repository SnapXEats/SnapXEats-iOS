//
//  SnapNShareHomeViewController.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SnapNShareHomeViewController: BaseViewController, StoryboardLoadable {

    private let photoCreatedDatePrefix = "Photo taken on "
    
    // MARK: Properties
    var presenter: SnapNShareHomePresentation?
    var picker = UIImagePickerController()
    //TODO: Remove this hardcoded value once we get Id for Checkedin Restaurant
    var restaurant: Restaurant?
    var restaurantDetails: RestaurantDetails?
    var specialities = [RestaurantSpeciality]()
    var slideshow =  ImageSlideshow()
    var userDishReview = LoginUserPreferences.shared.userDishReview
    private var shouldLoadData: Bool {
        get {
            return checkRechability() && restaurantDetails == nil
        }
    }
    
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var closingTimeLabel: UILabel!
    @IBOutlet var checkinTimeLabel: UILabel!
    @IBOutlet var specialityCollectionView: UICollectionView!
    @IBOutlet var slideshowCountLabel: UILabel!
    @IBOutlet var slideshowContainer: UIView!
    
    @IBAction func takeSnapButtonAction(_ sender: UIButton) {
        openCameraPicker()
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRestaurantDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slideshow.frame = slideshowContainer.frame
        slideshowContainer.addSubview(slideshow)
    }
    
    override func success(result: Any?) {
        if let result = result as? RestaurantDetailsItem {
            hideLoading()
            restaurantDetails = result.restaurantDetails
            showRestaurantDetails()
        }
    }
    
    private func getRestaurantDetails() {
        if shouldLoadData == true {
            showLoading()
            if let restaurant = self.restaurant, let id = restaurant.restaurant_info_id {
                userDishReview.restaurantInfoId = id // This ID is needed while sending reviewPhoto, Audio and rating in SnapNSharePhotoViewController
                presenter?.restaurantDetailsRequest(restaurantId:id)
            }
        }
    }
    
    private func openCameraPicker() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func gotoSnapNSharePhotoViewWithPhoto(photo: UIImage) {
        if let parentNVCpntroller = self.navigationController {
            presenter?.gotoSnapNSharePhotoView(parent: parentNVCpntroller, withPhoto: photo)
        }
    }
    
    private func showRestaurantDetails() {
        if let details = restaurantDetails {
            restaurantNameLabel.text = details.name ?? SnapXEatsAppDefaults.emptyString
            specialities = details.specialities
            specialityCollectionView.reloadData()
            setupImageSlideshowWithPhotos(photos: details.photos)
        }
    }
    
    func setupImageSlideshowWithPhotos(photos: [RestaurantPhoto]) {
        var inputsources = [AlamofireSource]()
        for photo in photos {
            if let photoURLString = photo.imageURL, let source = AlamofireSource(urlString: photoURLString) {
                inputsources.append(source)
            }
        }
        slideshow.setImageInputs(inputsources)
        slideshow.contentScaleMode = .scaleAspectFit
        slideshow.slideshowInterval = 0
        slideshow.pageControlPosition = .hidden
        slideshow.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: .black)
        
        //Show details for First item which is by default selected
        slideshowCountLabel.text = "1/\(inputsources.count)"
        
        // Call back of image changed event
        slideshow.currentPageChanged = { [weak self] (index) in
            self?.slideshowCountLabel.text = "\(index+1)/\(inputsources.count)"
        }
    }
    
    private func savePhoto(image: UIImage) {
        if let photoPathURL = getPathForSmartPhotoForRestaurant() {
            do {
                try UIImageJPEGRepresentation(image, 1.0)?.write(to: photoPathURL, options: .atomic)
                
            } catch {
                print("file cant not be saved at path \(photoPathURL), with error : \(error)")
            }
        }
    }
}

extension SnapNShareHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            dismiss(animated: true) {
                self.savePhoto(image: chosenImage)
                self.gotoSnapNSharePhotoViewWithPhoto(photo: chosenImage)
            }
        }
    }
}

extension SnapNShareHomeViewController: SnapNShareHomeView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: false)
        picker.delegate = self
        registerCellForNib()
    }
    
    private func registerCellForNib() {
        let nib = UINib(nibName: SnapXEatsNibNames.restaurantSpecialityCollectionViewCell, bundle: nil)
        specialityCollectionView.register(nib, forCellWithReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantSpeciality)
    }
}

extension SnapNShareHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return specialities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnapXEatsCellResourceIdentifiler.restaurantSpeciality, for: indexPath) as! RestaurantSpecialityCollectionViewCell
        cell.configureSpecialityCell(specialityItem: specialities[indexPath.row])
        return cell
    }
}

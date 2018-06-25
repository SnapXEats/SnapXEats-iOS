//
//  SnapNShareHomeViewController.swift
//  SnapXEats
//
//  Created by synerzip on 14/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class SnapNShareHomeViewController: BaseViewController, StoryboardLoadable {

    private let photoCreatedDatePrefix = "Photo taken on "
    
    // MARK: Properties
    var presenter: SnapNShareHomePresentation?
    //TODO: Remove this hardcoded value once we get Id for Checkedin Restaurant
    var restaurantID: String?
    var restaurantDetails: RestaurantDetails?
    var specialities = [RestaurantSpeciality]()
    var slideshow =  ImageSlideshow()
    var userDishReview = LoginUserPreferences.shared.userDishReview
    var displayFromNotification: Bool = false
    private var shouldLoadData: Bool {
        get {
            return checkRechability() && restaurantDetails == nil
        }
    }
    
    private var isCheckedIn: Bool {
        return CheckInHelper.shared.isCheckedIn()
    }
    
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var closingTimeLabel: UILabel!
    @IBOutlet weak var checkinTimeLabel: UIButton!
    @IBOutlet var specialityCollectionView: UICollectionView!
    @IBOutlet var slideshowCountLabel: UILabel!
    @IBOutlet var slideshowContainer: UIView!
    
    @IBAction func takeSnapButtonAction(_ sender: UIButton) {
        isCheckedIn ? CamerPicker.camperPicker(view: self) : showChecInError()
    }
    
    func showChecInError() {
        let Ok = UIAlertAction(title: SnapXButtonTitle.ok, style: UIAlertActionStyle.default, handler: { [weak self] action in
            self?.presenter?.presentScreen(screens: .location)
        })
        UIAlertController.presentAlertInViewController(self, title: AlertTitle.checkInTitle , message: AlertMessage.checkInMessage, actions: [Ok], completion: nil)
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
             checkinTimeLabel.isHidden = false
            restaurantDetails = result.restaurantDetails
            showRestaurantDetails()
        }
    }
    
    private func getRestaurantDetails() {
        if shouldLoadData == true {
            showLoading()
            if let restaurantid = restaurantID {
                userDishReview.restaurantInfoId = restaurantid // This ID is needed while sending reviewPhoto, Audio and rating in SnapNSharePhotoViewController
                presenter?.restaurantDetailsRequest(restaurantId: restaurantid)
            }
        }
    }
    
    private func gotoSnapNSharePhotoViewWithPhoto(photo: UIImage) {
        if let parentNVCpntroller = self.navigationController, let _  = restaurantDetails?.id {
            presenter?.presentScreen(screens: .snapNSharePhoto(photo: photo, iparentController: parentNVCpntroller, restaurantDetails: restaurantDetails))
        }
    }
    
    private func showRestaurantDetails() {
        if let details = restaurantDetails {
            restaurantNameLabel.text = details.name ?? SnapXEatsAppDefaults.emptyString
            specialities = details.specialities
            specialityCollectionView.reloadData()
            setupImageSlideshowWithPhotos(photos: details.photos)
            if displayFromNotification == false {
                presenter?.presentScreen(screens: .reminderPopUp(rewardsPoint: 50, restaurantID: restaurantDetails?.id, delegate: self))
            }
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
        slideshow.pageControlPosition = .insideScrollView
        slideshow.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: .black)
       // slideshow.pageControlPosition = .hidden   //un comment the code to show numbers on slides 

//        //Show details for First item which is by default selected
//        slideshowCountLabel.text = "1/\(inputsources.count)"
//
//        // Call back of image changed event
//        slideshow.currentPageChanged = { [weak self] (index) in
//            self?.slideshowCountLabel.text = "\(index+1)/\(inputsources.count)"
//        }
    }
    
    
}

extension SnapNShareHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            dismiss(animated: true) { [weak self] in
                resetImageSaveTimeInterval() // Reset value before saving new image to path, 
                if let restaurntId = self?.restaurantID, let photoPathURL = SmartPhotoPath.draft(fileName: fileManagerConstants.smartPhotoFileName, id: restaurntId).getPath() {
                        savePhoto(image: chosenImage, path: photoPathURL)
                    }
                self?.gotoSnapNSharePhotoViewWithPhoto(photo: chosenImage)
            }
        }
    }
}

extension SnapNShareHomeViewController: SnapNShareHomeView {
    func initView() {
        customizeNavigationItem(title: SnapXEatsPageTitles.snapnshare, isDetailPage: false)
        CamerPicker.picker.delegate = self
        checkinTimeLabel.isHidden = true
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


extension SnapNShareHomeViewController: CameraMode {
    func showCamera() {
         CamerPicker.camperPicker(view: self)
    }
}

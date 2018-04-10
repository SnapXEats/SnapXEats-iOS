//
//  smartPhotoViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SmartPhotoViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: SmartPhotoPresentation?

    @IBOutlet weak var smartPhotoImage: UIImageView!
    // MARK: Lifecycle
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    var smartPhoto: SmartPhoto?
    var dishID: String?
    
    @IBAction func infoButtonAction(_ sender: Any) {
        presenter?.presentView(view: .info)
    }
    

    @IBAction func messageButtonAction(_ sender: Any) {
         presenter?.presentView(view: .message)
    }
    @IBAction func audioButtonAction(_ sender: Any) {
        presenter?.presentView(view: .audio)
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        presenter?.presentView(view: .download)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = dishID, smartPhoto == nil {
            presenter?.getSmartPhotoDetails(dishID: id)
        }
    }
    
    override func success(result: Any?) {
        if let smartPhoto = result as? SmartPhoto {
            self.smartPhoto = smartPhoto
            loadSmartPhoto()
        }
    }
    
    func loadSmartPhoto() {
        if let url = smartPhoto?.dish_image_url, let imageURL = URL(string: url) {
            smartPhotoImage.af_setImage(withURL: imageURL, placeholderImage:UIImage(named: SnapXEatsImageNames.restaurant_speciality_placeholder)!)
        }
    }
}

extension SmartPhotoViewController: SmartPhotoView {
    func initView() {
        containerView.layer.cornerRadius = PopupConstants.containerViewRadius
        containerView.addShadow()
    }
    
    // TODO: implement view output methods
}

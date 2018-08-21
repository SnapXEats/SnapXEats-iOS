
//
//  SmartPhotoTableViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 14/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class SmartPhotoTableViewController: BaseViewController {
    
    @IBOutlet weak var smartPhotoTableView: UITableView!
    var smartPhotos: [SmartPhoto]?
    var delegate: SmartPhotoDraftWireframe?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        registerNibForCell()
        smartPhotos = SmartPhotoHelper.shared.getSmartPhotos()
    }
    
    var smartPhotoItemCount = [Int]()
    private func registerNibForCell() {
        let tableViewCellNib = UINib(nibName: SnapXEatsNibNames.smartPhotoTableCell, bundle: nil)
        smartPhotoTableView.register(tableViewCellNib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.smartPhotTableView)
        smartPhotoTableView.separatorColor = UIColor.clear
    }
}


extension SmartPhotoTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  smartPhotos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if let photo = self.smartPhotos, let smartPhoto_Draft_Stored_id = photo[indexPath.row].smartPhoto_Draft_Stored_id,
                let dishId = photo[indexPath.row].restaurant_item_id, let parent = self.navigationController {
                self.delegate?.presentScreen(screen: .smartPhoto(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, dishID: dishId, type: .downlaodedSmartPhoto, parentController: parent))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SnapXEatsAppDefaults.smartPhotTableRowheight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.smartPhotTableView, for: indexPath) as! SmartPhotoTableCell
        cell.selectionStyle = .none
        if let photos = smartPhotos, let imageUrl = apptoDocumentDirPath(path: photos[indexPath.row].dish_image_url) {
            if FileManager.default.fileExists(atPath: imageUrl.path) {
                print(imageUrl.path)
                cell.smartPhotoImage.image =   UIImage(contentsOfFile: imageUrl.path)
            }
            cell.restaurantNameLabel.text = photos[indexPath.row].restaurant_name
            cell.smartPhot_Draft_id = photos[indexPath.row].smartPhoto_Draft_Stored_id
            cell.shareButton.isHidden = true
        }
        
        return cell
    }
}


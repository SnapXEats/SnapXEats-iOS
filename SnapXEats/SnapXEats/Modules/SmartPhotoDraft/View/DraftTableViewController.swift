//
//  DraftTableViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 14/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

class DraftTableViewController: BaseViewController {
    
    @IBOutlet weak var draftTableView: UITableView!
    
    var draftPhotos: [SmartPhoto]?
    
    weak var delegate: SmartPhotoDraftWireframe?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        registerNibForCell()
        draftPhotos = SmartPhotoHelper.shared.getDraftPhotos()
    }
    
    var draftItemCount = [Int]()
    private func registerNibForCell() {
        let tableViewCellNib = UINib(nibName: SnapXEatsNibNames.smartPhotoTableCell, bundle: nil)
        draftTableView.register(tableViewCellNib, forCellReuseIdentifier: SnapXEatsCellResourceIdentifiler.smartPhotTableView)
        draftTableView.separatorColor = UIColor.clear
    }
}


extension DraftTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  draftPhotos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let photo = draftPhotos, let smartPhoto_Draft_Stored_id = photo[indexPath.row].smartPhoto_Draft_Stored_id,
            let dishId = photo[indexPath.row].restaurant_item_id, let parent = self.navigationController {
            delegate?.presentScreen(screen: .smartPhoto(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, dishID: dishId, type: .draftPhoto, parentController: parent))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SnapXEatsAppDefaults.smartPhotTableRowheight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.smartPhotTableView, for: indexPath) as! SmartPhotoTableCell
        cell.selectionStyle = .none
        if let photos = draftPhotos, let imageUrl = apptoDocumentDirPath(path: photos[indexPath.row].dish_image_url) {
            if FileManager.default.fileExists(atPath: imageUrl.path) {
                print(imageUrl.path)
                cell.smartPhotoImage.image =   UIImage(contentsOfFile: imageUrl.path)
            }
            cell.restaurantNameLabel.text = photos[indexPath.row].restaurant_name
            cell.smartPhot_Draft_id = photos[indexPath.row].smartPhoto_Draft_Stored_id
            cell.delegate = self
        }
       
        return cell
    }
}

extension DraftTableViewController :TableCelldelegate {
    func showLoginScreen(id: String?) {
        if let smartPhoto_Draft_Stored_id = id, let parent = self.navigationController {
            delegate?.presentScreen(screen: .loginPopUp(storedID: smartPhoto_Draft_Stored_id, parentController: parent, loadFromSmartPhot_Draft: true))
        }
    }
    
    func navigateScreen(id: String?) {
        if let smartPhoto_Draft_Stored_id = id, let parent = self.navigationController {
            delegate?.presentScreen(screen: .snapAndShareFromDraft(smartPhoto_Draft_Stored_id: smartPhoto_Draft_Stored_id, parentController: parent))
        }
    }
}

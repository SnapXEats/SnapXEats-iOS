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
        }
        return cell
    }
}

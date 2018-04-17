
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SnapXEatsAppDefaults.smartPhotTableRowheight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SnapXEatsCellResourceIdentifiler.smartPhotTableView, for: indexPath) as! SmartPhotoTableCell
        cell.selectionStyle = .none
        cell.smartPhotoImage.image =  UIImage(named: SnapXEatsImageNames.wishlist_placeholder)!
        cell.restaurantNameLabel.text = "Brand New"
        return cell
    }
}


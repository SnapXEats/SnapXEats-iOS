//
//  SelectLocationViewController.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 23/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import UIKit

enum SelectLocationResourceIdentifiler {
    static let savedLocationCellIdentifier = "SavedLocationCell"
    static let savedLocationNibName = "SavedLocationTableViewCell"
    static let SavedAddressHeaderViewCellIdentifier = "SavedAddressHeaderCell"
    static let SavedAddressHeaderNibName = "SavedAddressHeaderViewCell"
    static let searchPlaceCell = "SearchPlaceCell"
    static let searchPlaceNibName = "SearchPlacesTableViewCell"
}

struct SavedAddress {
    var tilte: String
    var address: String
    var imageName: String
}

class SelectLocationViewController: BaseViewController, StoryboardLoadable {

    let savedLocationHeaderHeight: CGFloat = 35.0
    
    var presenter: SelectLocationPresentation?
    var savedAddresses = [SavedAddress]()
    var searchPlaces = [SearchPlace]()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var locationsTableview: UITableView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    @IBAction func closeSelectLocation(_ sender: Any) {
        presenter?.dismissScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        createSavedAddressesDataSource()
    }
    
    override func success(result: Any?) {
        if let result = result as? SearchPlacePredictions {
            self.searchPlaces = result.palceList
            locationsTableview.reloadData()
        }
    }
    
    func configureView() {
        locationsTableview.tableFooterView = UIView()
        configureSearchBar()
        topView.addShadow()
        registerCellForNib()
    }
    
    private func configureSearchBar() {
        locationSearchBar.setFont(textFont: UIFont(name: Constants.Font.roboto_regular, size: 14.0))
        locationSearchBar.backgroundImage = UIImage()
        locationSearchBar.layer.borderWidth = 0.5
        locationSearchBar.layer.borderColor = UIColor.rgba(232.0, 232.0, 232.0, 1).cgColor
    }
    
    func registerCellForNib() {
        let tableCellNib = UINib(nibName: SelectLocationResourceIdentifiler.savedLocationNibName, bundle: nil)
        locationsTableview.register(tableCellNib, forCellReuseIdentifier: SelectLocationResourceIdentifiler.savedLocationCellIdentifier)
        
        let tableHeaderNib = UINib(nibName: SelectLocationResourceIdentifiler.SavedAddressHeaderNibName, bundle: nil)
        locationsTableview.register(tableHeaderNib, forCellReuseIdentifier: SelectLocationResourceIdentifiler.SavedAddressHeaderViewCellIdentifier)
        
        let searchPlaceNib = UINib(nibName: SelectLocationResourceIdentifiler.searchPlaceNibName, bundle: nil)
        locationsTableview.register(searchPlaceNib, forCellReuseIdentifier: SelectLocationResourceIdentifiler.searchPlaceCell)
    }
    
    func createSavedAddressesDataSource() {
        let homeAddress = SavedAddress(tilte: "Home", address: "4278 Webster street,  Edison, NJ", imageName: "home_icon")
        let workAddress = SavedAddress(tilte: "Work", address: "1994 Webster street,  Edison, NJ", imageName: "work_icon")
        savedAddresses = [homeAddress, workAddress]
    }
}

extension SelectLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchPlaces = []
        if (searchText == "") { // If nothing in search, reload table with blank Dataspurce
            locationsTableview.reloadData()
        } else {
            presenter?.getSearchPlaces(searchText: searchText)
        }
    }
}

extension SelectLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return savedAddresses.count
        return searchPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectLocationResourceIdentifiler.searchPlaceCell, for: indexPath) as! SearchPlacesTableViewCell
        
        //let address = savedAddresses[indexPath.row]
        //cell.configureSavedAddressCell(savedAddress: address)
        
        let place = searchPlaces[indexPath.row]
        cell.descriptionLabel.text = place.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return savedLocationHeaderHeight
        return 1
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableCell(withIdentifier: SelectLocationResourceIdentifiler.SavedAddressHeaderViewCellIdentifier) as! SavedAddressHeaderViewCell
//        return headerView
//    }
}

extension SelectLocationViewController: SelectLocationView {
    func initView() {
        
    }
    
    // TODO: implement view output methods
}

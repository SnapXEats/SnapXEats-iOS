//
//  RestaurantDetailsViewController.swift
//  
//
//  Created by Durgesh Trivedi on 19/02/18.
//  
//

import Foundation
import UIKit

class RestaurantDetailsViewController: BaseViewController, StoryboardLoadable {

    // MARK: Properties

    var presenter: RestaurantDetailsPresentation?
    var restaurant: Restaurant!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RestaurantDetailsViewController: RestaurantDetailsView {
    func initView() {
        
    }
    
    // TODO: implement view output methods
}

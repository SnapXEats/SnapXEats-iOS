//
//  UserPreferenceInteractor.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 01/02/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class UserPreferenceInteractor {

    // MARK: Properties
    var output: UserPreferenceInteractorOutput?
    static let shared = UserPreferenceInteractor()
    private init() {}
}

extension UserPreferenceInteractor: UserPreferenceInteractorIntput {
    func saveUserPreference(selectedPreference: SelectedPreference) {
        PreferenceHelper.shared.saveUserPrefernce(preference: selectedPreference)
    }
    
    func getUserPreference(userID: String) {
        if let prefernce = PreferenceHelper.shared.getUserPrefernce(userID: userID){
            output?.response(result: .success(data: prefernce))
        }
    }
}

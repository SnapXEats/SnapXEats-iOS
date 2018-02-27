//
//  DrawerContract.swift
//  
//
//  Created by Durgesh Trivedi on 22/02/18.
//  
//

import Foundation
import UIKit

protocol DrawerView: BaseView {
    var presenter: DrawerPresentation? { set get }
}

protocol DrawerPresentation: DrawerUseCase {
    func presentScreen(screen: Screens, drawerState: KYDrawerController.DrawerState)
    func presnetScreen(screen: Screens)
}


protocol DrawerInteractorOutput: Response {
    // TODO: Declare interactor output methods
}


protocol DrawerWireframe: RootWireFrame {
    func presentScreen(screen: Screens, drawerState: KYDrawerController.DrawerState)
}


protocol DrawerUseCase: class {
    func saveUserPreference(loginUserPreferences: LoginUserPreferences)
    func getUserPreference(userID: String)
    func sendUserPreference(preference: LoginUserPreferences)
    func updateUserPreference(preference: LoginUserPreferences)
}

protocol DrawerInteractorIntput: DrawerRequestFormatter {
    func saveUserPreference(loginUserPreferences: LoginUserPreferences)
    func getUserPreference(userID: String)
}

protocol DrawerRequestFormatter: class {
    func sendUserPreference(preference: LoginUserPreferences)
    func updateUserPreference(preference: LoginUserPreferences)
}

protocol DrawerWebService: class {
    func sendUserPreferences(forPath: String, withParameters: [String: Any])
    func updateUserPreferences(forPath: String, withParameters: [String: Any])
}

protocol DrawerObjectMapper: class {
    func userPreferenceResult(code: Int)
}

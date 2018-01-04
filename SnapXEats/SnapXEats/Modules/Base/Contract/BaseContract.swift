//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation

protocol BaseView: class {
    func showLoading()
    func hideLoading()
    func showError(_ message: String?)
    func showMessage(_ message: String?, withTitle title: String?)
}

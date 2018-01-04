//
//  DataResponse.swift
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation
import Alamofire


extension DataResponse {
    
    var isSuccess: Bool {
        get {
            guard let statusCode = response?.statusCode else { return false }
            if 200 ... 299 ~= statusCode {
                return true
            } else {
                return false
            }
        }
    }
}

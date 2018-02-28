//
//  SnapXEats
//  Created by Durgesh Trivedi on 03/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.

import Foundation
import ObjectMapper


class UserProfile: Mappable {
    var userInfo: UserInfo?
    required init?(map: Map) {
    }
    
     func mapping(map: Map) {
        userInfo <- map["userInfo"]
    }
}

class UserInfo: Mappable {
    var token: String?
    var user_id: String?
    var social_platform: String?
    var first_time_login: Bool = false
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        user_id <- map["user_id"]
        social_platform <- map["social_platform"]
        first_time_login <- map["first_time_login"]
    }
}

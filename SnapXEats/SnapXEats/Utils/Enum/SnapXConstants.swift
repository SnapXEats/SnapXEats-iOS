//
//  SnapXEnum.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 10/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation


enum InstagramConstant {
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_CLIENT_ID = "739cbd7da5c048fbab575487859602c9"
    static let INSTAGRAM_CLIENTSERCRET = "9df371b962c945e69c2e3f5603ab1a32"
    static let INSTAGRAM_REDIRECT_URI = "http://www.snapxeats.com"
    static let INSTAGRAM_ACCESS_TOKEN = "access_token"
    static let INSTAGRAM_SCOPE = "follower_list+public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
    static let INSTAGRAM_AUTH_STRING = "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True"
    static let INSTAGRAM_LOGGEDIN = "instagramLoggedIn"
    case instagramURL
    
    private func getString() -> String {
        return  String(format: InstagramConstant.INSTAGRAM_AUTH_STRING, arguments: [InstagramConstant.INSTAGRAM_AUTHURL,InstagramConstant.INSTAGRAM_CLIENT_ID,InstagramConstant.INSTAGRAM_REDIRECT_URI, InstagramConstant.INSTAGRAM_SCOPE])
    }
    
    func getRequest() -> URLRequest {
        let string = getString()
        return URLRequest.init(url: URL.init(string: string)!)
    }
}

enum SnapXEatsConstant {
    case buildVersion
    
    func getBuildVersion() -> String {
        var buildVersion = ""
        if let showBuildVersion = Bundle.main.infoDictionary!["BuildVersion"] as? Bool, showBuildVersion == true {
            let appBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            buildVersion = "V-\(appVersion)-Build-\(appBuildNumber)"
        }
        return buildVersion
    }
}

enum SnapXEatsStoryboard {
    static let loginStoryboard = "Login"
    static let locationStoryboard = "Location"
}

enum SnapXEatsStoryboardIdentifier {
    static let loginViewControllerID = "LoginViewController"
    static let instagramViewControllerID = "InstagramViewController"
    static let locationViewControllerID = "LocationViewController"
}

enum SnapXEatsWebServiceResourcePath {
    static let  port = "3000"
    static let  root = "http://ec2-18-216-193-78.us-east-2.compute.amazonaws.com:" + port
    static let  cuisinePreference =   root + "/api/v1/cuisine"
}

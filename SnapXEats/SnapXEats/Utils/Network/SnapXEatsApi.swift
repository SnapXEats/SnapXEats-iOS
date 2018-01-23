//
//  SnapXEatsAPI.swift
//  SnapXEats
//
//  Created by Durgesh Trivedi on 22/01/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum HTTPRequestHeaderKey: String {
    case authorization = "Authorization"
}

class SnapXEatsApi {
    
    static var uploadRequest: Request?
    
    static var baseURL: String {
        return SnapXEatsWebServiceResourcePath.root
    }
    
    static func snapXRequestObject<T: Mappable>(path: String, completionHandler:  @escaping (DataResponse<T>) -> ()) {
        Alamofire.request(path).responseObject( completionHandler: completionHandler)
    }
    
    static func snapXRequestObjectArray<T: Mappable>(path: String, completionHandler: @escaping (DataResponse<[T]>) -> ()) {
        Alamofire.request(path).responseArray( completionHandler: completionHandler)
    }
   
}

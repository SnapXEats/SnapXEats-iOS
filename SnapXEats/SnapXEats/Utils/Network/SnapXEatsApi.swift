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
        return SnapXEatsWebServicePath.rootURL
    }
    
    static func snapXRequestObject<T: Mappable>(path: String, completionHandler:  @escaping (DataResponse<T>) -> ()) {
         let url = baseURL + path
        Alamofire.request(url).responseObject( completionHandler: completionHandler)
    }
    
    static func snapXRequestObjectArray<T: Mappable>(path: String, completionHandler: @escaping (DataResponse<[T]>) -> ()) {
        let url = baseURL + path
        Alamofire.request(url).responseArray( completionHandler: completionHandler)
    }
    
    static func snapXRequestObjectWithParameters<T: Mappable>(path: String, parameters: [String: Any], completionHandler:  @escaping (DataResponse<T>) -> ()) {
         let url = baseURL + path
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseObject( completionHandler: completionHandler)
    
    }

}

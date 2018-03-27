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
    static let loginUserPrefernce = LoginUserPreferences.shared
    static var baseURL: String {
        return SnapXEatsWebServicePath.rootURL
    }
    
    static let serverToken = SnapXEatsLoginHelper.shared.getLoginUserServerToken()
    
    static var header: [String: String]? {
        if let loginToken = loginUserPrefernce.loginServerToken, loginUserPrefernce.isLoggedIn {
            return [SnapXEatsWebServiceParameterKeys.authorization : SnapXEatsWebServiceParameterKeys.BearerString + loginToken]
        }
        return nil
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
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseObject( completionHandler: completionHandler)
    
    }
    
    static func snapXPostRequestObjectWithParameters<T: Mappable>(path: String, parameters: [String: Any], completionHandler:  @escaping (DataResponse<T>) -> ()) {
        let url = baseURL + path
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header).responseObject( completionHandler: completionHandler)
        
    }
    
    static func snapXPostRequestMutiPartObjectWithParameters<T: Mappable>(path: String, parameters: [String: Any], completionHandler:  @escaping (DataResponse<T>) -> (), failureCallback: @escaping (Error) -> Void) {
        let url = baseURL + path
        do {
            // Get Image and Audio data to upload
            let imageData = try Data(contentsOf: LoginUserPreferences.shared.userDishReview.dishPicture!)
            let audioData = try Data(contentsOf: LoginUserPreferences.shared.userDishReview.reviewAudio!)

            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "dishPicture", fileName: "smart_photo.jpeg", mimeType: "image/jpg")
                multipartFormData.append(audioData, withName: "audioReview", fileName: "audio_review.m4a", mimeType: "audio/mpeg")
                for (key, value) in parameters {
                    if value is String || value is Int {
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                }
            }, to:url, method: .post, headers: header)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseObject(completionHandler: completionHandler)
                case .failure(let encodingError):
                    failureCallback(encodingError)
                }
            }
        } catch {
            print("Unable to load data: \(error)")
            failureCallback(error)
        }
    }
    
    static func snapXPutRequestObjectWithParameters<T: Mappable>(path: String, parameters: [String: Any], completionHandler:  @escaping (DataResponse<T>) -> ()) {
        let url = baseURL + path
        Alamofire.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: header).responseObject( completionHandler: completionHandler)
    }

    static func snapXPostRequestWithParameters(path: String, parameters: [String: Any], completionHandler:  @escaping (DefaultDataResponse) -> ()) {
        let url = baseURL + path
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).response { (data) in
            completionHandler(data)
        }
    }
    
    static func snapXPutRequestWithParameters(path: String, parameters: [String: Any], completionHandler:  @escaping (DefaultDataResponse) -> ()) {
        let url = baseURL + path
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header).response { (data) in
            completionHandler(data)
        }
    }
    
    static func snapXGetRequestWithParameters(path: String, parameters: [String: Any], completionHandler:  @escaping (DefaultDataResponse) -> ()) {
        let url = baseURL + path
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).response { (data) in
            completionHandler(data)
        }
    }
    
    static func snapXDelteRequestWithParameters(path: String, parameters: [String: Any], completionHandler:  @escaping (DefaultDataResponse) -> ()) {
        let url = baseURL + path
        Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: header).response { (data) in
            completionHandler(data)
        }
    }
    
    static func googleRequestObjectWithParameters<T: Mappable>(path: String, parameters: [String: Any], completionHandler:  @escaping (DataResponse<T>) -> ()) {
        Alamofire.request(path, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseObject( completionHandler: completionHandler)
        
    }
    
    static func googleRequestObject<T: Mappable>(path: String, completionHandler:  @escaping (DataResponse<T>) -> ()) {
        Alamofire.request(path).responseObject( completionHandler: completionHandler)
    }
}

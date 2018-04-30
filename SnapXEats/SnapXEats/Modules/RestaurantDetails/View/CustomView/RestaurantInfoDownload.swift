//
//  RestaurantInfoDownloadViewController.swift
//  SnapXEats
//
//  Created by Priyanka Gaikwad on 27/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import AVFoundation
import UICircularProgressRing
import Alamofire

class RestaurantInfoDownload: UIView, UICircularProgressRingDelegate {
    
    @IBOutlet weak var progressBar: UICircularProgressRingView!

    var smartPhoto: SmartPhoto?
    weak var delegate: RestaurantDetailsPresentation?
    weak var internetdelegate: RestaurantDetailsWireframe?
    
    let utilityQueue = DispatchQueue.global(qos: .utility)
    func initView() {
        progressBar.outerCapStyle = .round
        progressBar.delegate = self
        progressBar.ringStyle = .ontop
        if let on = internetdelegate?.checkInternet(), on {
            startDownloading()
        }
    }
    
    func startDownloading() {
        if let imageUrl  = smartPhoto?.dish_image_url, let url = URL(string: imageUrl) {
            downloadData(url: url,imagedata: true)
        }
    }
    
    func downloadData(url: URL, imagedata: Bool = false, audioData: Bool = false) {
        Alamofire.request(url).downloadProgress(queue: DispatchQueue.main, closure: { (progress) in
            let porg = Int(progress.fractionCompleted * 100)
            self.progressBar.setProgress(value: CGFloat(porg), animationDuration: 0.05) {
            }
        }).responseData(completionHandler: { [weak self] (response) in
            let data = response.result
            self?.smartPhotoDetail(data: data, imagedata: imagedata, audioData:  audioData)
        })
    }
    
    func smartPhotoDetail(data: Result<Data>, imagedata: Bool = false, audioData: Bool = false) {
        switch data {
        case .success(let value):
            var imageDownloadSuccess = false
            var audioDownloadSuccess = false
            if imagedata {
                imageDownloadSuccess = savePhotoFile(value: value)
            } else if  audioData {
                audioDownloadSuccess = saveAudio(data: value)
            }
            
            if let audioURL =  smartPhoto?.audio_review_url, let url = URL(string: audioURL), imageDownloadSuccess {
                downloadData(url: url, audioData: true)
            } else if imageDownloadSuccess || audioDownloadSuccess {
                delegate?.showSuccess()
            }
            
            
        case .failure( _):
            internetdelegate?.checkInternet()
        }
    }
    
    func savePhotoFile(value: Data) -> Bool {
        resetImageSaveTimeInterval() // before saving data we need to reset the timeinterval every time, to creat new stored ID
        if let saveFilePath =  getImageFilePath(), let image = UIImage(data: value) {
            saveSmartPhotoInfo() // save the info in Realm data base
            return  savePhoto(image: image, path: saveFilePath)
        }
        return false
    }
    
    func saveAudio(data: Data) -> Bool {
        if let saveFilePath = getAudioFilePath() {
            return  saveAudioFile(value: data, path: saveFilePath)
        }
        return false
    }
    
    func saveSmartPhotoInfo() {
        if let photo = smartPhoto, let imagURL = getImageFilePath(), let imagePath = getPathTillDocDir(path: imagURL.absoluteString) {
            let smartPhoto = SmartPhoto()
            
            smartPhoto.dish_image_url =  imagePath
            if let audioURL = getAudioFilePath() , let audiopath = getPathTillDocDir(path: audioURL.absoluteString) {
                smartPhoto.audio_review_url = audiopath
            }
            smartPhoto.restaurant_name = photo.restaurant_name
            smartPhoto.restaurant_address = photo.restaurant_address
            smartPhoto.restaurant_aminities = photo.restaurant_aminities
            smartPhoto.restaurant_item_id = photo.restaurant_item_id
            smartPhoto.smartPhoto_Draft_Stored_id = getTimeInterval()
            smartPhoto.text_review = photo.text_review
            delegate?.saveSmartPhoto(smartPhoto: smartPhoto)
        }
    }
    
    func getImageFilePath() -> URL? {
        if let fileName = getFileName(filePath: smartPhoto?.dish_image_url), let id = smartPhoto?.restaurant_item_id,
            let filePath = SmartPhotoPath.smartPhoto(fileName: fileName, id: id).getPath() {
            return filePath
        }
        return nil
    }
    
    func getAudioFilePath() -> URL? {
        if let fileName = getFileName(filePath: smartPhoto?.audio_review_url), let id = smartPhoto?.restaurant_item_id,
            let saveFilePath = SmartPhotoPath.smartPhoto(fileName: fileName, id: id).getPath() {
            return saveFilePath
        }
        return nil
    }
}

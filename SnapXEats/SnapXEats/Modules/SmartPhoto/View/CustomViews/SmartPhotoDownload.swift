//
//  AudioRecordingPopUp.swift
//  SnapXEats
//
//  Created by synerzip on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import AVFoundation
import UICircularProgressRing
import Alamofire

protocol SuccessScreen: class {
    func showSuccess()
}
class SmartPhotoDownload: UIView, UICircularProgressRingDelegate {
    
    @IBOutlet weak var progressBar: UICircularProgressRingView!
    var smartPhoto: SmartPhoto?
    weak var delegate: SuccessScreen?
    weak var internetdelegate: SmartPhotoWireframe?
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
        if let fileName = getFileName(filePath: smartPhoto?.dish_image_url), let id = smartPhoto?.restaurant_dish_id,
            let image = UIImage(data: value),  let saveFilePath = SmartPhotoPath.smartPhoto(fileName: fileName, id: id).getPath() {
            return  savePhoto(image: image, path: saveFilePath)
        }
        return false
    }
    
    func saveAudio(data: Data) -> Bool {
        if let fileName = getFileName(filePath: smartPhoto?.audio_review_url), let id = smartPhoto?.restaurant_dish_id,
            let saveFilePath = SmartPhotoPath.smartPhoto(fileName: fileName, id: id).getPath() {
            return  saveAudioFile(value: data, path: saveFilePath)
        }
        return false
    }
    
}



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

class SmartPhotoDownload: UIView, UICircularProgressRingDelegate {
    
    @IBOutlet weak var progressBar: UICircularProgressRingView!
    var imageURL: String?
    var audioURL: String?
    let utilityQueue = DispatchQueue.global(qos: .utility)
    func initView() {
        progressBar.outerCapStyle = .round
        progressBar.delegate = self
        progressBar.ringStyle = .ontop
        startDownloading()
    }
    
    func startDownloading() {
        if let imageUrl  = imageURL,  let url = URL(string: imageUrl) {
            Alamofire.download(url)
                .downloadProgress { progress in
                    let porg = CGFloat(progress.totalUnitCount/progress.completedUnitCount)
                    self.progressBar.setProgress(value: porg, animationDuration: 2) {
                        // self.progressBar.font = UIFont.systemFont(ofSize: 50)
                        print("Download Progress: \(porg)")
                    }

                }
                .responseData { response in
                    if let data = response.result.value {
                        let image = UIImage(data: data)
                    }
            }
           
        }
    }
}



//
//  PlayAudioPopUp.swift
//  SnapXEats
//
//  Created by Priyanka Gaikwad on 24/04/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioPopUp: UIView {

    //MARK: Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet var playAudioStartButton: UIButton!
    @IBOutlet var playAudioOkayButton: UIButton!
    @IBOutlet var audioDurationLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    //MARK: Properties
    var parentController: UIViewController!
    var seconds = 0
    var audioPlayer: AVAudioPlayer?
    var timer = Timer()
    var audioURL: String?
    var dishId: String?

    func setupPopup(_ frame: CGRect, url:String, type: AudioRecordingPopupTypes, forDuration seconds: Int, forViewController vc: UIViewController) {
        self.frame = frame
        self.seconds = 0
        self.parentController = vc

        containerView.layer.cornerRadius = popupConstants.containerViewRadius
        containerView.addShadow()
        playAudioOkayButton.layer.cornerRadius = playAudioOkayButton.frame.height/2
        playAudioStartButton.addBorder(ofWidth: popupConstants.startButtonBorderWidth, withColor: .lightGray, radius: playAudioStartButton.frame.width/2)
        audioURL = url
        audioDurationLabel.text = timeString(time: TimeInterval(seconds))
        
    }
    
    @IBAction func playAudioAction(_ sender: Any) {
        playAudioReview()
    }
    
    @IBAction func okayAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    private func playAudioReview() {
        if let audioUrl = audioURL, let url = URL(string: audioUrl) {
            do {
                
                let soundData = try Data(contentsOf: url)
                audioPlayer = try AVAudioPlayer(data: soundData)
                do {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                }
                audioPlayer?.play()
                runTimer()
            } catch (let error) {
                print("Unable to Play Audio", error)
            }
        }
        
    }
    
    func runTimer() {
        audioDurationLabel.text = timeString(time: TimeInterval(seconds))
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds = seconds - 1
        audioDurationLabel.text = timeString(time: TimeInterval(seconds))
    }

}

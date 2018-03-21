//
//  AudioRecordingPopUp.swift
//  SnapXEats
//
//  Created by synerzip on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioRecordingPopUpViewActionsDelegate: class {
    func audioRecordingDone(_ popupView: AudioRecordingPopUp, forDuration duration: Int)
    func audioPlaybackDone(_ popupView: AudioRecordingPopUp)
    func audioRecordingDeleted(_ popupView: AudioRecordingPopUp)
}

enum AudioRecordingPopupTypes {
    case record
    case play
}

class AudioRecordingPopUp: UIView {

    enum popupConstants {
        static let containerViewRadius: CGFloat = 5.0
        static let startButtonBorderWidth: CGFloat = 1.0
        static let recordPopupTitle = "ADD AUDIO REVIEW"
        static let playPopupTitle = "AUDIO REVIEW"
        static let maxAudioLengthInSeconds = 30
    }
    
    weak var audioRecordingPopupDelegate: AudioRecordingPopUpViewActionsDelegate?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    var timer = Timer()
    var seconds = 0
    var audioReviewDuration = 0
    var popupType: AudioRecordingPopupTypes!
    var parentController: UIViewController!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var recordAudioStartButton: UIButton!
    @IBOutlet var recordAudioDoneButton: UIButton!
    @IBOutlet var audioDurationLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var removeReviewButton: UIButton!
    
    @IBAction func recordingDoneAction(_ sender: UIButton) {
        if popupType == .record {
            finishRecording()
        } else {
            audioPlayer?.stop()
            audioRecordingPopupDelegate?.audioPlaybackDone(self)
        }
    }
    
    @IBAction func recordingStartAction(_ sender: UIButton) {
        (popupType == .record) ? prepareForAudioRecording() : playAudioReview()
    }
    
    @IBAction func deleteReviewButtonAction(_ sender: UIButton) {
        showDeleteAudioReviewConfirmation()
    }
    
    func setupPopup(_ frame: CGRect, type: AudioRecordingPopupTypes, forDuration seconds: Int, forViewController vc: UIViewController) {
        self.frame = frame
        self.popupType = type
        self.seconds = seconds
        self.audioReviewDuration = seconds
        self.parentController = vc
        containerView.layer.cornerRadius = popupConstants.containerViewRadius
        containerView.addShadow()
        recordAudioDoneButton.layer.cornerRadius = recordAudioDoneButton.frame.height/2
        recordAudioStartButton.addBorder(ofWidth: popupConstants.startButtonBorderWidth, withColor: .lightGray, radius: recordAudioStartButton.frame.width/2)
        
        recordAudioDoneButton.isEnabled = (type == .record) ? false : true
        recordAudioDoneButton.alpha = (type == .record) ? 0.5 : 1.0
        
        (type == .record) ? removeReviewButton.isInactive() : removeReviewButton.isActive()
        titleLabel.text = (type == .record) ? popupConstants.recordPopupTitle : popupConstants.playPopupTitle
        let imageName = (type == .record) ? SnapXEatsImageNames.record_popuup_icon : SnapXEatsImageNames.play_popuup_icon
        recordAudioStartButton.setImage(UIImage(named:imageName), for: .normal)
        audioDurationLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    private func prepareForAudioRecording() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startAudioRecording()
                    } else {
                        print("failed to record!")
                    }
                }
            }
        } catch {
            print("failed to record!")
        }
    }
    
    private func startAudioRecording() {
        if let audioRecordingURL = getPathForAudioReviewForRestaurant() {
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            do {
                audioRecorder = try AVAudioRecorder(url: audioRecordingURL, settings: settings)
                audioRecorder.record()
                runTimer()
                recordAudioDoneButton.isActive()
                recordAudioStartButton.isEnabled = false
            } catch {
                print("failed to Record!")
            }
        }
    }
    
    private func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        timer.invalidate()
        
        recordAudioDoneButton.isInactive()
        audioRecordingPopupDelegate?.audioRecordingDone(self, forDuration: seconds)
    }
    
    private func playAudioReview() {
        if let audioRecordingURL = getPathForAudioReviewForRestaurant() {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioRecordingURL)
                do {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
                }
                audioPlayer?.play()
                recordAudioStartButton.isEnabled = false
                runTimer()
            } catch {
                print("Unable to Play Audio")
            }
        }
    }
    
    func runTimer() {
        audioDurationLabel.text = timeString(time: TimeInterval(seconds))
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds = popupType == .record ? seconds + 1 : seconds - 1
        audioDurationLabel.text = timeString(time: TimeInterval(seconds))
        if seconds >= popupConstants.maxAudioLengthInSeconds { // Auto sto Recording after Max limit
            finishRecording()
            showAudioReviewLimitReachedAlert()
        } else if seconds == 0 {
            recordAudioStartButton.isEnabled = true
            timer.invalidate()
            seconds = popupType == .play ? audioReviewDuration : seconds
        }
    }
    
    private func showAudioReviewLimitReachedAlert() {
        let maxLimitReachedAlert = UIAlertController(title: SnapXEatsAppDefaults.emptyString, message: AlertMessage.maxAudioReviewLimitReached, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: SnapXButtonTitle.ok, style: .cancel, handler: nil)
        maxLimitReachedAlert.addAction(okAction)
        parentController.present(maxLimitReachedAlert, animated: true, completion: nil)
    }
    
    private func showDeleteAudioReviewConfirmation() {
        let confirmationAlert = UIAlertController(title: SnapXEatsAppDefaults.emptyString, message: AlertMessage.audioReviewDeleteConfirmation, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: SnapXButtonTitle.notnow, style: .cancel, handler: nil)
        confirmationAlert.addAction(noAction)
        
        let yesAction = UIAlertAction(title: SnapXButtonTitle.yes, style: .default) { (_) in
            self.deleteAudioReview()
        }
        confirmationAlert.addAction(yesAction)
        parentController.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func deleteAudioReview() {
        // Delete the Audio Recording from documents directory as well
        if let audioFileURL = getPathForAudioReviewForRestaurant() {
            do {
                try FileManager.default.removeItem(at: audioFileURL)
            } catch {
                print("Unable to Delete File")
            }
        }
        audioRecordingPopupDelegate?.audioRecordingDeleted(self)
    }
}


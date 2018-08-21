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
    var audioPlayer: AVAudioPlayer?
    var audioURL: String?
    var dishId: String?
    var jukebox: Jukebox?

    func setupPopup(_ frame: CGRect, url:String, type: AudioRecordingPopupTypes, forDuration seconds: Int, forViewController vc: UIViewController) {
        self.frame = frame
        self.parentController = vc

        containerView.layer.cornerRadius = popupConstants.containerViewRadius
        containerView.addShadow()
        playAudioOkayButton.layer.cornerRadius = playAudioOkayButton.frame.height/2
        audioURL = url
        
        if let audio = audioURL, let url = URL(string: audio) {
            UIApplication.shared.beginReceivingRemoteControlEvents()
            jukebox = Jukebox(delegate: self, items: [JukeboxItem(URL: url)])
        }
    }
    
    @IBAction func playAudioAction(_ sender: Any) {
        switch jukebox?.state {
            case .playing? :
                jukebox?.pause()
            case .paused? :
                jukebox?.play()
            default:
                jukebox?.stop()
        }
        jukebox?.play()
    }
    
    @IBAction func okayAction(_ sender: Any) {
        jukebox?.stop()
        self.removeFromSuperview()
    }
    
    func pausePlayer() {
        jukebox?.pause()
        jukebox = nil
    }

}

extension PlayAudioPopUp : JukeboxDelegate {
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.playAudioStartButton.alpha = jukebox.state == .loading ? 0 : 1
            self.playAudioStartButton.isEnabled = jukebox.state == .loading ? false : true
        })
        
        if jukebox.state == .ready {
            playAudioStartButton.setImage(#imageLiteral(resourceName: "play_popup_icon"), for: UIControlState())
        } else if jukebox.state == .loading  {
            playAudioStartButton.setImage(#imageLiteral(resourceName: "pause_popup_icon"), for: UIControlState())
        } else {
            let imageName: String
            switch jukebox.state {
            case .playing, .loading:
                imageName = "pause_popup_icon"
            case .paused, .failed, .ready:
                imageName = "play_popup_icon"
            }
            playAudioStartButton.setImage(UIImage(named: imageName), for: UIControlState())
        }
        
        print("Jukebox state changed to \(jukebox.state)")
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        if let currentTime = jukebox.currentItem?.currentTime, let duration = jukebox.currentItem?.meta.duration {
            let value = Float(currentTime / duration)
            populateLabelWithTime(audioDurationLabel, time: currentTime)
        } else {
            resetUI()
        }
    }
    
    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        
    }
    
    func jukeboxDidUpdateMetadata(_ jukebox: Jukebox, forItem: JukeboxItem) {
        
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if let jukebox = jukebox {
            if event?.type == .remoteControl {
                switch event!.subtype {
                case .remoteControlPlay :
                    jukebox.play()
                case .remoteControlPause :
                    jukebox.pause()
                case .remoteControlNextTrack :
                    jukebox.playNext()
                case .remoteControlPreviousTrack:
                    jukebox.playPrevious()
                case .remoteControlTogglePlayPause:
                    if jukebox.state == .playing {
                        jukebox.pause()
                    } else {
                        jukebox.play()
                    }
                default:
                    break
                }
            }
        }
    }
    
    // MARK:- Helpers -
    
    func populateLabelWithTime(_ label : UILabel, time: Double) {
        let minutes = Int(time / 60)
        let seconds = Int(time) - minutes * 60
        
        label.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
    
    
    func resetUI()
    {
        audioDurationLabel.text = "00:00"
    }
}

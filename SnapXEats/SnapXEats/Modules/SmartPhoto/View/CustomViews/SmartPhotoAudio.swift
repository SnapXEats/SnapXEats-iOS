//
//  AudioRecordingPopUp.swift
//  SnapXEats
//
//  Created by synerzip on 19/03/18.
//  Copyright © 2018 SnapXEats. All rights reserved.
//

import UIKit
import AVFoundation


class SmartPhotoAudio: UIView {
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    var audioURL: String?
    var jukebox: Jukebox?
    weak var delegate: SmartPhotoWireframe?
    
    @IBAction func playButton(_ sender: Any) {
        if let on =  delegate?.checkInternet(), on {
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
    }
    
    func initView() {
        if let auidoUrl = audioURL, let url = URL(string: auidoUrl) {
            UIApplication.shared.beginReceivingRemoteControlEvents()
            jukebox = Jukebox(delegate: self, items: [JukeboxItem(URL: url)])
        }
        
    }
    
    func stopPlayer() {
         jukebox?.stop()
         jukebox = nil
    }
    
}

extension SmartPhotoAudio:  JukeboxDelegate {
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.playPauseButton.alpha = jukebox.state == .loading ? 0 : 1
            self.playPauseButton.isEnabled = jukebox.state == .loading ? false : true
        })
        
        if jukebox.state == .ready {
            playPauseButton.setImage(#imageLiteral(resourceName: "play_popup_icon"), for: UIControlState())
        } else if jukebox.state == .loading  {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause_popup_icon"), for: UIControlState())
        } else {
            let imageName: String
            switch jukebox.state {
            case .playing, .loading:
                imageName = "pause_popup_icon"
            case .paused, .failed, .ready:
                imageName = "play_popup_icon"
            }
            playPauseButton.setImage(UIImage(named: imageName), for: UIControlState())
        }
        
        print("Jukebox state changed to \(jukebox.state)")
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        if let currentTime = jukebox.currentItem?.currentTime, let duration = jukebox.currentItem?.meta.duration {
            let value = Float(currentTime / duration)
            populateLabelWithTime(currentTimeLabel, time: currentTime)
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
        currentTimeLabel.text = "00:00"
    }
}



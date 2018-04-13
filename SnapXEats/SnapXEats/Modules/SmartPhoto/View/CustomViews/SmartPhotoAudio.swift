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
    
    
    var audioURL: String?
    var jukebox: Jukebox?
    weak var delegate: SmartPhotoWireframe?
    @IBAction func playButton(_ sender: Any) {
        if let on =  delegate?.checkInternet(), on {
          jukebox?.play()
        }
    }
    func initView() {
        if let auidoUrl = audioURL, let url = URL(string: auidoUrl) {
            UIApplication.shared.beginReceivingRemoteControlEvents()
            jukebox = Jukebox(delegate: self, items: [JukeboxItem(URL: url)])
        }
        
    }
    
    func pausePlayer() {
         jukebox?.pause()
         jukebox = nil
    }
    
}

extension SmartPhotoAudio:  JukeboxDelegate {
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        
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
}



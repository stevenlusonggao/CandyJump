//
//  musicplayer.swift
//  GUI
//
//  Created by Lu Gao on 2018-03-22.
//  Copyright © 2018 Lu Gao. All rights reserved.
//

import AVFoundation
import UIKit

class musicplayer {  //music player
    static var backgroundMusicPlayer: AVAudioPlayer?
    static var playing: Bool = false
    static var firsttime = true
    
    static func playm() {
        if firsttime == true {
            firsttime = false
        }
        let url = Bundle.main.url(forResource: "themesong.mp3", withExtension: nil)
        do {
            try backgroundMusicPlayer = AVAudioPlayer(contentsOf: url!)
        } catch {
            print("Could not create audio player")
        }
        backgroundMusicPlayer!.numberOfLoops = -1
        backgroundMusicPlayer!.prepareToPlay()
        backgroundMusicPlayer!.play()
        playing = true
    }
    static func stopm() {
        backgroundMusicPlayer!.stop()
        playing = false
    }
    
}


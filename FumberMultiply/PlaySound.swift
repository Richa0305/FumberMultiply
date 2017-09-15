//
//  PlaySound.swift
//  Officer Spiderman
//
//  Created by Srivastava, Richa on 20/06/17.
//  Copyright © 2017 ShivHari Apps. All rights reserved.
//

import Foundation
import AVFoundation

class PlaySound: NSObject {
    static var soundPlayer: AVAudioPlayer?
    static func playSound(fileName:String,extn:String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: extn) else {
            print("error")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = soundPlayer else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    static var backgroundMusicPlayer = AVAudioPlayer()
    
    static func playBackgroundMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.volume = 0.1
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    static func stopBackgroundMusic(){
        backgroundMusicPlayer.stop()
    }
}

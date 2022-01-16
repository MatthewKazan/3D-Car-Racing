//
//  music.swift
//  Builder
//
//  Created by matt kazan on 5/1/20.
//  Copyright © 2020 matt kazan. All rights reserved.
//

import Foundation
import AVFoundation

class MusicHelper {
    static let sharedHelper = MusicHelper()
    var audioPlayer: AVAudioPlayer?
    var clank: AVAudioPlayer! = nil
   
   func playSound(sound: String){
        let path = Bundle.main.path(forResource: sound, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.ambient)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1

            audioPlayer?.play()
        } catch {
            print("couldn't load the file")
        }
    }
    
    func clang() {
        let filePath = Bundle.main.path(forResource: "engine", ofType: "mp3")
        let fileURL = NSURL.fileURL(withPath: filePath!)
          do {
            clank = try? AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
            clank?.numberOfLoops = -1
            clank?.volume = 0.5
            clank.prepareToPlay()
            //clank.delegate = self
            clank.play()
          } catch {
              
          }
        clank?.play()
        print("playing")
    }
    func stop() {
        clank?.stop()
    }
}

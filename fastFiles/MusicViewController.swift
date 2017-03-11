//
//  MusicViewController.swift
//  fastFiles
//
//  Created by Adrian on 22.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MusicViewController: UIViewController {

    // Variables
    @IBOutlet weak var Artwork: UIImageView!
    @IBOutlet weak var time: UISlider!
    @IBOutlet weak var musicTitle: UITextView!
    
    var artist = ""
    var _title = ""
    
    var url: URL!
    var audio = AVAudioPlayer()
    var audioList: [URL]! = []
    
    var currAudio = 0
    
    var pause = false
    
    var stopped = false
    
    var timer = Timer()
    
    var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    
    // Actions
    
    @IBAction func timeControl(_ sender: Any) { // Time slider
        audio.currentTime = TimeInterval(time.value)
    }
    
    @IBAction func Play(_ sender: Any) { // Play or pause music
        if audio.isPlaying {
            audio.pause()
            self.pause = true
        } else {
            audio.play()
            self.pause = false
        }
    }
    
    @IBAction func Rewind(_ sender: Any) { // Rewind button
        print("PREVIOUS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        self.currAudio = self.currAudio-1
        self.audio.stop()
        self.audio.currentTime = 0
        
        if self.currAudio < self.audioList.count && self.currAudio > 0 {
            self.url = self.audioList[self.currAudio]
        } else {
            self.currAudio = 0
            self.url = self.audioList[self.currAudio]
        }
        
        self.playMusic()
    }
    
    
    @IBAction func Next(_ sender: Any) { // Next button
        print("NEXT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        self.currAudio = self.currAudio+1
        self.audio.stop()
        self.audio.currentTime = 0
        
        if self.currAudio < self.audioList.count {
            self.url = self.audioList[self.currAudio]
        } else {
            self.currAudio = 0
            self.url = self.audioList[self.currAudio]
        }
        
        self.playMusic()
    }


}

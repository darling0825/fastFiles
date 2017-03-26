//
//  Other functions (MusicViewController).swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


/*
                                                 Functions
 */

extension MusicViewController {
    func stop() { // Stop COMPLETLY the music
        audio.stop()
        pause = true
        //MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
        stopped = true
        print("file://"+Bundle.main.path(forResource: "Silence", ofType: "mp3")!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        audio = try! AVAudioPlayer(contentsOf: URL(string:"file://"+Bundle.main.path(forResource: "Silence", ofType: "mp3")!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        audioList = [URL(string:"file://"+Bundle.main.path(forResource: "Silence", ofType: "mp3")!)!]
        timer.invalidate()
    }
    
    func playMusic() { // Play audio
        
        Artwork.image = #imageLiteral(resourceName: "MissingArtworkMusic.png") // Default artwork
        
        _title = ""
        artist = ""
        
        do { // Prepare audio
            audio = try AVAudioPlayer(contentsOf: url)
            audio.prepareToPlay()
            audio.play()
            
            // Start background session
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
            
            
        } catch let error {
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        // Set slider values
        time.maximumValue = Float(audio.duration)
        
        
        self.title = url!.lastPathComponent // Set title
        
        
        let metaData = AVPlayerItem(url: url).asset.metadata
        var info: [String: Any] = [:]
        
        for item in metaData { // Get music info
            if item.commonKey == "artwork" { // Artwork
                if let image = UIImage(data: item.dataValue!) {
                    self.Artwork.image = image
                    info[MPMediaItemPropertyArtwork] = item.stringValue
                }
            }
            
            if item.commonKey == "title" { // Title
                if item.stringValue != "" {
                    self._title = item.stringValue!
                    info[MPMediaItemPropertyTitle] = item.stringValue
                }
            }
            
            if item.commonKey == "artist" { // Artist
                if item.stringValue != "" {
                    self.artist = item.stringValue!
                    info[MPMediaItemPropertyArtist] = item.stringValue
                }
            }
        }
        
        
        if _title != "" {
            print(_title)
            self.musicTitle.text = _title
            if artist != "" {
                print(artist)
                self.musicTitle.text = self.musicTitle.text+", "+artist
            }
        } else {
            print("HAS NO TITLE")
            musicTitle.text = url.lastPathComponent.replacingOccurrences(of: "."+url.pathExtension, with: "")
        }
        
    }

}

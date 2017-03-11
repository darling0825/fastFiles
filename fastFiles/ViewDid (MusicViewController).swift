//
//  ViewDid (MusicViewController).swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


/*                                    View did
                                        load
 */


extension MusicViewController {
    
    
    override func viewDidLoad() {
        
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: { // Start background task
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
        })
        
        UIApplication.shared.beginReceivingRemoteControlEvents() // Start receiving controls from ControlCenter or LockScreen
        setControls()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Stop"), object: nil) // Stop previous music
        NotificationCenter.default.addObserver(self, selector: #selector(stop), name: NSNotification.Name(rawValue: "Stop"), object: nil) // Stop music when other music is played
        
        // Set buttons content mode
        playButton.imageView?.contentMode = .scaleAspectFit
        previousButton.imageView?.contentMode = .scaleAspectFit
        nextButton.imageView?.contentMode = .scaleAspectFit
        
        playMusic() // Play music
        
        audioList = [] // Reset audio list
        
        let subURL = URL(string: url.absoluteString.replacingOccurrences(of: url.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!, with: "")) // Directory from is the audio
        
        print(subURL!)
        print(url.lastPathComponent)
        
        let subURLContent = try! FileManager.default.contentsOfDirectory(at: subURL!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) // Directory from is the audio content
        print(subURLContent)
        
        for item in subURLContent { // Get all audios in this directory and add to audioList
            if ((try? AVAudioPlayer(contentsOf: item)) != nil) && item != url {
                print("URLs")
                print(item)
                print(url)
                audioList.append(item)
            }
        }
        
        audioList.insert(url, at: 0) // Add the current audio at the first of audioList
        print(audioList)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in // A timer
            
            if !self.time.isSelected { // Show current time in slider if slider is not selected
                self.time.value = Float(self.audio.currentTime)
            }
            
            if !self.audio.isPlaying && !self.pause { // Play next audio if the current is finish
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
            
            if self.audio.isPlaying {
                self.playButton.imageView?.image = #imageLiteral(resourceName: "Pause.png")
            } else {
                self.playButton.imageView?.image = #imageLiteral(resourceName: "Play.png")
            }
            
            self.getAudioInfo() // Get current audio info
        }
    }
}

//
//  Controls.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

/*
                                                     ControlCenter or LockScreen
                                                           muisc controls
 */

extension MusicViewController {
    func setControls() {
        let commandCenter = MPRemoteCommandCenter.shared() // Command Center
        commandCenter.nextTrackCommand.isEnabled = true // Enable "Next" button
        commandCenter.nextTrackCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in // Set "Next" button
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
            
            return MPRemoteCommandHandlerStatus.success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true // Enable "Previous" button
        commandCenter.previousTrackCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in // Set "Previous" button
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
            
            return MPRemoteCommandHandlerStatus.success
        }
        
        commandCenter.pauseCommand.isEnabled = true // Enable "Pause" button
        commandCenter.pauseCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in // Set "Pause" button
            self.audio.pause()
            self.pause = true
            
            return MPRemoteCommandHandlerStatus.success
        }
        
        commandCenter.playCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in // Set "Play" button
            self.audio.play()
            self.pause = false
            
            return MPRemoteCommandHandlerStatus.success
        }

    }
}

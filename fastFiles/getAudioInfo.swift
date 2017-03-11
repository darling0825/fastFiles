//
//  getAudioInfo.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

/*
                                            Get current audio
                                                  info
 */

extension MusicViewController {
    func getAudioInfo() {
        let metaData = AVPlayerItem(url: self.url).asset.metadata
        var info: [String: Any] = [:]
        let defaultArtwork = MPMediaItemArtwork(image: self.Artwork.image!)
        
        info[MPMediaItemPropertyArtwork] = defaultArtwork
        
        info[MPMediaItemPropertyTitle] = self.audio.url?.lastPathComponent
        for item in metaData {
            if item.commonKey == "artwork" { // Artwork
                if let image = UIImage(data: item.dataValue!) {
                    self.Artwork.image = image
                    if let image = UIImage(data: item.dataValue!) {
                        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
                    }
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
        
        if !self.stopped { // Set info
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        }

    }
}

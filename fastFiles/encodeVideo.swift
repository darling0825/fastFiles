//
//  encodeVideo.swift
//  fastFiles
//
//  Created by Adrian on 25.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

extension BrowserTableViewController {
    func encodeVideo(videoURL: NSURL)  {
        let avAsset = AVURLAsset(url: videoURL as URL, options: nil)
        
        //Create Export session
        exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        
        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        //Creating temp path to save the converted video
        
        
        let documentsDirectory = App().delegate().docsURL.path
        let myDocumentPath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4")?.absoluteString
        _ = NSURL(fileURLWithPath: myDocumentPath!)
        
        let documentsDirectory2 = App().delegate().docsURL
        
        let filePath = documentsDirectory2?.appendingPathComponent((videoURL.deletingPathExtension!.lastPathComponent+".mp4"))
        deleteFile(filePath: filePath! as NSURL)
        
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath!) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath!)
            }
            catch let error {
                print(error)
            }
        }
        
        
        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileTypeMPEG4
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, 0)
        let range = CMTimeRangeMake(start, avAsset.duration)
        exportSession?.timeRange = range
        
        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch self.exportSession!.status {
            case .failed:
                print("%@",self.exportSession?.error!)
            case .cancelled:
                print("Export canceled")
            case .completed:
                //Video conversion finished
                
                print(time)
                print("Successful!")
                try! FileManager.default.removeItem(at: videoURL as URL)
                try! FileManager.default.moveItem(at: filePath!, to: videoURL as URL)
                self.reload()
                print(self.exportSession.outputURL!)
                
            default:
                break
            }
            
        })
        
        
    }
    
    func deleteFile(filePath:NSURL) {
        guard FileManager.default.fileExists(atPath: filePath.path!) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path!)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
}

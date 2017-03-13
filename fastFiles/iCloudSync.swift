//
//  webServer.swift
//  fastFiles
//
//  Created by Adrian on 11.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                     iCloud
                                      sync
 */

extension AppDelegate {
    func iCloudSync() {
        if let iCloudDrive = App().iCloudDrive() {
            if !FileManager.default.fileExists(atPath: iCloudDrive.path) {
                do {
                    try FileManager.default.createDirectory(at: iCloudDrive, withIntermediateDirectories: true, attributes: [:])
                } catch let error {
                    print("ERROR:\(error.localizedDescription)")
                }
            }
            
        }
    }
}

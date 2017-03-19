//
//  SendFile.swift
//  fastFiles
//
//  Created by Adrian on 18.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import Messages
import AVFoundation

extension MessagesViewController {
    func sendFile(url:URL!) {
        let conversation = activeConversation
 
            
        conversation?.insertAttachment(url, withAlternateFilename: url.lastPathComponent, completionHandler: { (Error) in
            conversation?.insertText(url.lastPathComponent, completionHandler: { (Error) in
                self.dismiss()
                self.extensionContext?.cancelRequest(withError: "Sended file" as! Error)
            })
        })
    }
}

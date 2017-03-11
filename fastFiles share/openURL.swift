//
//  openURL.swift
//  fastFiles
//
//  Created by Adrian on 04.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                Open
                                URL
 */

extension ShareViewController {
    func openURL(url: NSURL) {
        print(url)
        let context = NSExtensionContext()
        context.open(url as URL, completionHandler: nil)
        
        var responder = self as UIResponder?
        
        while (responder != nil){
            if responder?.responds(to: Selector("openURL:")) == true{
                responder?.perform(Selector("openURL:"), with: url)
            }
            responder = responder!.next
        }
    }
}

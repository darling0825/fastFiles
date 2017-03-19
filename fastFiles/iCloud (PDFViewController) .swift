//
//  iCloud (PDFViewController) .swift
//  fastFiles
//
//  Created by Adrian on 18.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                                    iCloud
                                                     sync
 */

extension PDFViewController {
    func iCloud() {
        let keyStore = NSUbiquitousKeyValueStore.default()
        if let y = keyStore.object(forKey: (self.url!.lastPathComponent)) {
            self.webView.scrollView.setContentOffset(CGPoint(x:0,y:y as! CGFloat), animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in // Save current page
            let keyStore = NSUbiquitousKeyValueStore.default()
            let y = self.webView.scrollView.contentOffset.y
            
            print(y)
            
            keyStore.set(y, forKey: (self.url!.lastPathComponent))
            keyStore.synchronize()
        }
        
    }
    

}

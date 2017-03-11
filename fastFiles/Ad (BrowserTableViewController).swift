//
//  Ad (BrowserTableViewController).swift
//  fastFiles
//
//  Created by Adrian on 03.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import GoogleMobileAds

/*
                        Admob
                         Ad
 */

extension BrowserTableViewController: GADBannerViewDelegate {
    
    func showAd() { // Show ad
        Ad.adUnitID = App().adID
        Ad.rootViewController = self
        Ad.adSize = kGADAdSizeBanner
        Ad.frame.size.height = 50
        
        let request: GADRequest = GADRequest()
        Ad.load(request)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) { // Did fail to load
        Ad.isHidden = true
    }
}


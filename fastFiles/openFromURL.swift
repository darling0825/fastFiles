//
//  openFromURL.swift
//  fastFiles
//
//  Created by Adrian on 27.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                    Open from
                                       URL
 */

extension ViewController {
    func openFromURL() {
        App().delegate().urlOpened = true
        self.performSegue(withIdentifier: "openBrowser", sender: nil)
    }
}

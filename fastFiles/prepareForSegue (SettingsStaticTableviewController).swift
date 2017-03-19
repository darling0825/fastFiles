//
//  PrepareForSegue (SettingsStaticTableviewController).swift
//  fastFiles
//
//  Created by Adrian on 19.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension SettingsStaticTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Prepare for segue
        
        if segue.identifier == "Licenses" { // Open Licenses file
            if let nextVC = segue.destination as? BrowserTableViewController {
                nextVC.dir = Bundle.main.path(forResource: "Licenses", ofType: "")!
            }
        }
        
    }
}

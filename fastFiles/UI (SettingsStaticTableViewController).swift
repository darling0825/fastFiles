//
//  UI (SettingsStaticTableViewController).swift
//  fastFiles
//
//  Created by Adrian on 19.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension SettingsStaticTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.tag == 1 { // Open licences
            self.performSegue(withIdentifier: "Licenses", sender: nil)
        }
        
        if tableView.cellForRow(at: indexPath)?.tag == 3 { // Open source code
            UIApplication.shared.open(URL(string:"https://github.com/ColdGrub1384/fastFiles")!)
        }
        
    }
}

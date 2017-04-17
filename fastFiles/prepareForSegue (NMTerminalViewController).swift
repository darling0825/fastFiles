//
//  prepareForSegue (NMTerminalViewController).swift
//  fastFiles
//
//  Created by Adrian on 16.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension SFTPTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ssh" { // SSH
            (segue.destination as! NMTerminalViewController).command = "cd '"+self.runCommand("pwd")!.replacingOccurrences(of: "\n", with: "")+"'"
        }
    }
}

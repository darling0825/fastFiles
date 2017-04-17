//
//  Commands.swift
//  fastFiles
//
//  Created by Adrian on 15.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import NMSSH

/*
                                            rm, rm -rf, mv
 */

extension SFTPTableViewController {
    
    func runCommand(_ command:String) -> String? {
        let session = NMSSHSession.connect(toHost: UserDefaults.standard.string(forKey: "IP"), withUsername: UserDefaults.standard.string(forKey: "USER"))
        if (session?.isConnected)! {
            print("CONNECT!")
            session?.authenticate(byPassword: UserDefaults.standard.string(forKey: "PASSWORD"))
            if (session?.isAuthorized)! {
                print("CONECTED!")
                do {
                    let result = try session!.channel.execute("cd '\(self.dir)'; "+command)
                    return result
                } catch _ {
                    return nil
                }
            }
        } else {
            return nil
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let rm = UITableViewRowAction(style: .destructive, title: "rm") { (action, indexPath) in
            print(self.runCommand("rm '\(self.dir)/\(self.files[indexPath.row])'")!)
            self.ListFiles()
            self.tableView.reloadData()
        }
        
        let rmrf = UITableViewRowAction(style: .destructive, title: "rm -rf") { (action, indexPath) in
            print(self.runCommand("rm -rf '\(self.dir)/\(self.files[indexPath.row])'")!)
            self.ListFiles()
        }
        
        var actions = [UITableViewRowAction]()
        
        // rm or rm -rf
        if isDir[indexPath.row] {
            actions.append(rmrf)
        } else {
            actions.append(rm)
        }
        
        return actions
    }
}

//
//  SettingsStaticTableViewController.swift
//  fastFiles
//
//  Created by Adrian on 19.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

class SettingsStaticTableViewController: UITableViewController {
    
    @IBOutlet weak var touchID: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchID.isOn = UserDefaults.standard.bool(forKey: "touchID")
        
    }
    
    @IBAction func enableTouchID(_ sender: Any) {
        UserDefaults.standard.set(touchID.isOn, forKey: "touchID")
    }
    
}

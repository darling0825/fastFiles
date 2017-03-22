//
//  SettingsStaticTableViewController.swift
//  fastFiles
//
//  Created by Adrian on 19.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

class SettingsStaticTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var sec: UITextField!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchID.isOn = UserDefaults.standard.bool(forKey: "touchID")
        sec.text = "\(UserDefaults.standard.value(forKey: "Refresh")!)"
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            self.doneBtn.isEnabled = self.sec.isFirstResponder
        }
    }
    
    @IBAction func enableTouchID(_ sender: Any) {
        UserDefaults.standard.set(touchID.isOn, forKey: "touchID")
    }
    
    
    @IBAction func done(_ sender: Any) {
        let int = Int(sec.text!)
        
        if int == nil {
            return
        }
        
        if int! < 3 {
            let alert = UIAlertController(title: "Continue", message: "Are you sure to set refresh time to \(int!) seconds? \nIt will be lagged!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                self.sec.text = "\(UserDefaults.standard.value(forKey: "Refresh")!)"
            }))
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (UIAlertAction) in
                UserDefaults.standard.set(int, forKey: "Refresh")
                UserDefaults.standard.synchronize()
                self.sec.resignFirstResponder()
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else if int! >= 5 {
            UserDefaults.standard.set(int, forKey: "Refresh")
            UserDefaults.standard.synchronize()
            sec.resignFirstResponder()
        }
    }
    
    
}

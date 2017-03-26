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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchID.isOn = UserDefaults.standard.bool(forKey: "touchID")
        sec.text = "\(UserDefaults.standard.value(forKey: "Refresh")!)"
        sec.delegate = self
    }
    
    @IBAction func enableTouchID(_ sender: Any) {
        UserDefaults.standard.set(touchID.isOn, forKey: "touchID")
    }
    
    
    func done() {
        let int = Int(sec.text!)
        
        if int == nil {
            return
        }
        
        if int! < 3 {
            let alert = UIAlertController(title: "Continue".localized, message: String.localizedStringWithFormat("Are you sure to set refresh time to %d seconds? \nIt will be lagged!".localized,int!), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (UIAlertAction) in
                self.sec.text = "\(UserDefaults.standard.value(forKey: "Refresh")!)"
            }))
            alert.addAction(UIAlertAction(title: "Continue".localized, style: .destructive, handler: { (UIAlertAction) in
                UserDefaults.standard.set(int, forKey: "Refresh")
                UserDefaults.standard.synchronize()
                self.sec.resignFirstResponder()
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            UserDefaults.standard.set(int, forKey: "Refresh")
            UserDefaults.standard.synchronize()
            sec.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        let doneBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "keyboard"), style: .done, target: self, action: #selector(done))
        toolbar.items = [doneBtn]
        
        textField.inputAccessoryView = toolbar
        
    }
    
}

//
//  NMTerminalViewController.swift
//  fastFiles
//
//  Created by Adrian on 16.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import NMSSH
import TZKeyboardPop

public class NMTerminalViewController: UIViewController, NMSSHSessionDelegate, NMSSHChannelDelegate, TZKeyboardPopDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var disconnect: UIBarButtonItem!
    @IBOutlet weak var terminal: UITextView!
    var session = NMSSHSession()
    
    var keyboard = TZKeyboardPop()
    
    var command = ""
    
    var host = UserDefaults.standard.string(forKey: "IP")
    var user = UserDefaults.standard.string(forKey: "USER")
    var password = UserDefaults.standard.string(forKey: "PASSWORD")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        terminal.layoutManager.allowsNonContiguousLayout = false
        terminal.isEditable = false
        terminal.isSelectable = false
        terminal.delegate = self
        
        keyboard = TZKeyboardPop(view: self.view)
        keyboard.delegate = self
        keyboard.showKeyboard()
        
        // Update text view size
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                
        session = NMSSHSession.connect(toHost: host, withUsername: user)
        if (session.isConnected) {
            session.authenticate(byPassword: password)
            if (session.isAuthorized) {
                session.channel.delegate = self
                session.delegate = self
                session.channel.requestSizeWidth(UInt(self.view.frame.size.width), height: UInt(self.view.frame.size.height))
                session.channel.requestPty = true
                
                do {
                    try session.channel.startShell()
                    session.channel.write(command+"\n", error: nil, timeout: 10)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        self.title = user!+"@"+host!
        
    }
    
    @IBAction func disconnect(_ sender: Any) {
        session.disconnect()
    }
    
    func channel(_ channel: NMSSHChannel!, didReadData message: String!) {
        DispatchQueue.main.async {
            self.terminal.text = self.terminal.text+message
        }
    }
    
    
    func didReturnKeyPressed(withText str: String!) {
        print(str)
        session.channel.write(str+"\n", error: nil, timeout: 10)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        let d = notification.userInfo!
        var r = d[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        r = self.terminal.convert(r, from:nil)
        self.terminal.contentInset.bottom = r.size.height+50
        self.terminal.scrollIndicatorInsets.bottom = r.size.height+50
        
    }
    
    func keyboardWillHide(_ notification:Notification) {
        self.terminal.contentInset = .zero
        self.terminal.scrollIndicatorInsets = .zero
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func channelShellDidClose(_ channel: NMSSHChannel!) {
        DispatchQueue.main.async {
            self.terminal.text = self.terminal.text+"\nConnection to \(self.host!) closed."
            self.keyboard.hide()
            self.title = ""
            self.disconnect.isEnabled = false
        }
    }
}

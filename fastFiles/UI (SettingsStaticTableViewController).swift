//
//  UI (SettingsStaticTableViewController).swift
//  fastFiles
//
//  Created by Adrian on 19.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI
import StoreKit

extension SettingsStaticTableViewController: MFMailComposeViewControllerDelegate, SKStoreProductViewControllerDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.tag == 1 { // Open licences
            self.performSegue(withIdentifier: "Licenses", sender: nil)
        }
        
        if tableView.cellForRow(at: indexPath)?.tag == 6 { // Send me an email
            let emailVC = MFMailComposeViewController()
            emailVC.setToRecipients(["adri_labbe@hotmail.com"])
            emailVC.setSubject("fastFiles beta subscription")
            emailVC.mailComposeDelegate = self
            
            self.present(emailVC, animated: true, completion: nil)
        }
        
        if tableView.cellForRow(at: indexPath)?.tag == 3 { // Open source code
            let safari = SFSafariViewController(url: URL(string:"https://github.com/ColdGrub1384/fastFiles")!)
            self.present(safari, animated: true, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.tag == 6 { // Testflight help
            let storeViewController = SKStoreProductViewController()
            storeViewController.delegate = self
            
            let parameters = [ SKStoreProductParameterITunesItemIdentifier : "899247664"]
            storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
                if loaded {
                    self?.present(storeViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

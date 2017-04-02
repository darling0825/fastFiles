//
//  TodayViewController.swift
//  Files
//
//  Created by Adrian on 18.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var TableView: UITableView!
    var docsContent: [URL]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        let defaults = UserDefaults(suiteName: "group.marcela.ada.files")
        if ((defaults?.array(forKey: "history")) != nil) {
            let data = defaults?.array(forKey: "history") as? [Data]
            docsContent = data?.map { URL(dataRepresentation: $0, relativeTo: nil)! }
            docsContent = docsContent.reversed()
            
            for doc in docsContent {
                if !FileManager.default.fileExists(atPath: doc.path) {
                    docsContent.remove(at: docsContent.index(of: doc)!)
                }
            }
            defaults?.set(docsContent.map { $0.dataRepresentation }, forKey: "history")
            self.TableView.reloadData()
            
            docsContent.reverse()
            
        } else {
            docsContent = try! FileManager.default.contentsOfDirectory(at: (FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:"group.marcela.ada.files")!.appendingPathComponent("File Provider Storage")), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize;
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: 220);
        }
    }
}

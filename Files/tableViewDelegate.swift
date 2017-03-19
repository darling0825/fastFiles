//
//  tableViewDelegate.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension TodayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Open file
        self.TableView.deselectRow(at: indexPath, animated: true)
        self.extensionContext?.open(docsContent[indexPath.row].urlScheme, completionHandler: nil)
    }
}

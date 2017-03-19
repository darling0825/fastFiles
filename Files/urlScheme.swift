//
//  App.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

extension URL {
    var urlScheme: URL {
        
        return URL(string:self.absoluteString.replacingOccurrences(of: "file://", with: "files://"))!
    }
}

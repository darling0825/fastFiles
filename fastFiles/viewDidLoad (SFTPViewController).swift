//
//  viewDidLoad (SFTPViewController).swift
//  fastFiles
//
//  Created by Adrian on 15.04.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

/*
                                        View did
                                          load
 */

extension SFTPViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ip.text = UserDefaults.standard.string(forKey: "IP")
        user.text = UserDefaults.standard.string(forKey: "USER")
        password.text = UserDefaults.standard.string(forKey: "PASSWORD")
    }
}

//
//  App.swift
//  fastFiles
//
//  Created by Adrian on 26.02.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit

class App {
    func delegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
    func allowedUTIs() -> [String] {
        return ["public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"]
    }
    
    let adID = "ca-app-pub-9214899206650515/7127479986"
    
    func iCloudDrive() -> URL? {
        return FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    func downloadFromCloud(directory:String) {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath:directory), includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
            
            for file in files {
                if file.lastPathComponent.hasPrefix(".") && file.pathExtension.lowercased() == "icloud" {
                    
                    var iCloudFileURL = file.deletingLastPathComponent()
                    iCloudFileURL = file
                    iCloudFileURL = iCloudFileURL.deletingPathExtension()
                    var str = iCloudFileURL.lastPathComponent
                    str.remove(at: str.startIndex)
                    str = iCloudFileURL.deletingLastPathComponent().appendingPathComponent(str).path
                    iCloudFileURL = URL(fileURLWithPath: str)
                    
                    do {
                        try FileManager.default.startDownloadingUbiquitousItem(at: iCloudFileURL)
                    } catch let error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                    
                    print(iCloudFileURL)
                }
            }
            
        } catch let error {
            print("ERROR:\(error.localizedDescription)")
        }
    }
    
    var libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    }
    
    var libraryURL: URL {
        return URL(fileURLWithPath:NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])
    }
    
    var tmpPath: String {
        return NSTemporaryDirectory()
    }
    
    var tmpURL: URL {
        return URL(fileURLWithPath:NSTemporaryDirectory())
    }
    
    var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    
    enum AppConfiguration {
        case Debug
        case TestFlight
        case Release
    }
    
    struct Config {
        // This is private because the use of 'appConfiguration' is preferred.
        private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
        
        // This can be used to add debug statements.
        static var isDebug: Bool {
            #if DEBUG
                return true
            #else
                return false
            #endif
        }
        
        static var appConfiguration: AppConfiguration {
            if isDebug {
                return .Debug
            } else if isTestFlight {
                return .TestFlight
            } else {
                return .Release
            }
        }
    }
}

extension URL {
    var urlScheme: URL {
        
        return URL(string:self.absoluteString.replacingOccurrences(of: "file://", with: "files://"))!
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UIImage {
    func withColor(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        let bounds = CGRect(x:0, y:0, width:size.width, height:size.height)
        UIRectFill(bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        return image!;
    }
    
    func from(systemItem: UIBarButtonSystemItem)-> UIImage? {
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        UIToolbar().setItems([tempItem], animated: false)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        for view in itemView.subviews {
            if let button = view as? UIButton, let imageView = button.imageView {
                return imageView.image
            }
        }
        
        return nil
    }
}

extension UITextView {
    
    static let ScrollModeBottom = "UITextFieldScrollModeBottom"
    static let ScrollModeUp = "UITextFieldScrollModeUp"
    static let ScrollModeMiddle = "UITextFieldScrollModeMiddle"
    
    func scrollToBotom() {
        let range = NSMakeRange((text as NSString).length - 1, 1);
        scrollRangeToVisible(range);
    }
    
    var scrollMode: String {
        let scrollViewHeight: Float = Float(frame.size.height)
        let scrollContentSizeHeight: Float = Float(contentSize.height)
        let scrollOffset: Float = Float(contentOffset.y)
        
        if scrollOffset == 0 {
            return UITextView.ScrollModeUp
        } else if scrollOffset + scrollViewHeight == scrollContentSizeHeight {
            return UITextView.ScrollModeBottom
        } else {
            return UITextView.ScrollModeMiddle
        }
    }
    
}

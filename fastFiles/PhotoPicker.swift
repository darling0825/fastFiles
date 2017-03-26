//
//  PhotoPicker.swift
//  fastFiles
//
//  Created by Adrian on 25.03.17.
//  Copyright © 2017 Adrian. All rights reserved.
//

import UIKit
import MobileCoreServices

/*
                                                    Import
                                                    image
 */

extension BrowserTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (info[UIImagePickerControllerMediaType] as! String) == kUTTypeMovie as String {
            let video = info[UIImagePickerControllerMediaURL] as! URL
            print(video)
            
            let alert = UIAlertController(title: "Select video name".localized, message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "File name".localized
            }
            
            alert.addAction(UIAlertAction(title: "Continue".localized, style: .default, handler: { (UIAlertAction) in
                try! FileManager.default.copyItem(at: video, to: URL(fileURLWithPath:self.dir+"/"+(alert.textFields?[0].text)!+".mov"))
                self.reload()
                self.encodeVideo(videoURL: NSURL(fileURLWithPath:self.dir+"/"+(alert.textFields?[0].text)!+".mov"))
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            
            picker.dismiss(animated: true) {
                self.present(alert, animated: true, completion: nil)
            }

        } else {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
            let alert = UIAlertController(title: "Select image name".localized, message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "File name".localized
            }
        
            alert.addAction(UIAlertAction(title: "Continue".localized, style: .default, handler: { (UIAlertAction) in
                FileManager.default.createFile(atPath: self.dir+"/"+(alert.textFields?[0].text)!+".png", contents: UIImagePNGRepresentation(image), attributes: nil)
                self.reload()
            }))
        
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
            picker.dismiss(animated: true) {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

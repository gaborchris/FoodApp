//
//  Coordinator.swift
//  Final
//
//  Created by Christian Gabor on 5/28/20.
//  Copyright © 2020 Christian Gabor. All rights reserved.
//

import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @ObservedObject var camera: CameraViewModel
    
    init(_ camera: CameraViewModel) {
        
        self.camera = camera
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            else {
                return
            }
        self.camera.image = Image(uiImage: unwrapImage)
        self.camera.showCapture = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.camera.showCapture = false
    }
}

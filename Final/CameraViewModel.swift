//
//  CameraViewModel.swift
//  Final
//
//  Created by Christian Gabor on 5/29/20.
//  Copyright © 2020 Christian Gabor. All rights reserved.
//


import UIKit
import SwiftUI

class CameraViewModel: ObservableObject {
    
    @Published var showCapture: Bool
    @Published var image: Image?
    @Published var predictions: [Food]
    
    init() {
        
        self.showCapture = true
        self.predictions = []
        self.predictions.append(Food(name: "Banana", date: Date()))
        self.predictions.append(Food(name: "Apple", date: Date()))
        self.predictions.append(Food(name: "Pear", date: Date()))
        self.predictions.append(Food(name: "Orange", date: Date()))
        self.predictions.append(Food(name: "Spinach", date: Date()))
        self.predictions.append(Food(name: "Watermellon", date: Date()))
       
    }
    
    
    
}

struct CaptureImageView {
    @ObservedObject var camera: CameraViewModel

    func makeCoordinator() -> Coordinator {
        return Coordinator(camera)
    }
}

extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        
        UINavigationBar.appearance().backgroundColor = .clear
            
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        let cameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
        if cameraAvailable {
            picker.sourceType = .camera
        }
        return picker
  
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>)
    {
        
    }
}

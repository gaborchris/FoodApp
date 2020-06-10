//
//  CameraViewModel.swift
//  Final
//
//  Created by Christian Gabor on 5/29/20.
//  Copyright © 2020 Christian Gabor. All rights reserved.
//


import UIKit
import SwiftUI
import CoreML
import Vision

class CameraViewModel: ObservableObject {
    
    @Published var showCapture: Bool
    @IBOutlet weak var modelImage: UIImageView!
    @Published var image: UIImage?
    @Published var predictions: [Food]

    init() {
        
        self.showCapture = true
        self.predictions = []
    }
    
    /// - Tag: MLModel
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: ImageClassifier().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func updateClassifications(for image: UIImage) {
         
         let orientation = CGImagePropertyOrientation(image.imageOrientation)
         guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
         
         DispatchQueue.global(qos: .userInitiated).async {
             let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
             do {
                 try handler.perform([self.classificationRequest])
             } catch {
                 print("Failed to perform classification.\n\(error.localizedDescription)")
             }
         }
     }
     
     func processClassifications(for request: VNRequest, error: Error?) {
         DispatchQueue.main.async {
             guard let results = request.results else {
                print("No results")
                 return
             }
       
             let classifications = results as! [VNClassificationObservation]
         
             if classifications.isEmpty {
                print("Nothing recognized")
             } else {
                 // Display top classifications ranked by confidence in the UI.
                 let topClassifications = classifications.prefix(5)
                var newPredictions: [Food] = []
                let timeStamp = Date()
                
                for i in 0..<5 {
                    let foodPrediction = Food(name: topClassifications[i].identifier, date: timeStamp)
                    newPredictions.append(foodPrediction)
                    
                }
                self.predictions = newPredictions
             }
         }
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

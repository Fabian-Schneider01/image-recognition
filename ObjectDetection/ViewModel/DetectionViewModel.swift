//
//  DetectionViewModel.swift
//  ObjectDetector
//
//  Created by Fabian Schneider on 19.06.22.
//

import CoreML
import SwiftUI
import Vision

class DetectionViewModel: ObservableObject {
    @Published var resultText = ""
    @Published var results: [String] = [""]
    @Published var listResults: [String] = ["", "", "", "", ""]
    
    var visionMLRequest: VNCoreMLRequest?
    
    init() {
        visionMLRequest = createVisionMLRequest()
    }
    
    func createVisionMLRequest() -> VNCoreMLRequest {
        let config = MLModelConfiguration()
        guard let mlModel = try? MobileNetV2(configuration: config).model else {
            fatalError("Couldn't load ML model")
        }
        guard let model = try? VNCoreMLModel(for: mlModel) else {
            fatalError("can't load the Vision Container ML model")
        }
        
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.resultText = "Unable to classify image."
                }
            } else {
                guard let classifications = request.results as? [VNClassificationObservation] else {
                    self.resultText = "Unable to classify image."
                    return
                }
                self.handleClassifications(classifications)
            }
        }
        request.imageCropAndScaleOption = .centerCrop
        return request
    }
    
    func handleClassifications(_ classifications: [ClassificationObservation]) {
        DispatchQueue.main.async {
            var resultText = ""
            self.results.removeAll()
            self.listResults.removeAll()
            for (index, result) in classifications.prefix(7).enumerated() {
                let confidence = String(format: "confidence: %.2f", result.confidence * 100)
                resultText = "\(result.identifier) (\(confidence)%)"
                self.listResults.append(resultText)
                if(result.identifier.contains(",")) {
                    let tmpResults = result.identifier.components(separatedBy: ", ")
                    self.results.append(tmpResults[0])
                } else {
                    self.results.append(result.identifier)
                }
            }
            self.resultText = resultText
            print(self.results)
            print(self.listResults)
        }
    }
    
    func classifyImage(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            print("Image creation failed.")
            DispatchQueue.main.async {
                self.resultText = "Can't load image."
            }
            return
        }
        
        guard let visionMLRequest = self.visionMLRequest else {
            print("ML Request not working.")
            return
        }
        
        resultText = "Image identification"
        
        let mlhandler = VNImageRequestHandler(ciImage: ciImage)
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try mlhandler.perform([visionMLRequest])
            } catch {
                print("Cant handle vision request \(error)")
            }
        }
    }
}

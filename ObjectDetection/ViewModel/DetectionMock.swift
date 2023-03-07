//
//  DetectionMock.swift
//  ObjectDetection
//
//  Created by Fabian Schneider on 15.06.22.
//

import Foundation
import Vision

extension VNClassificationObservation: ClassificationObservation {}

struct MockVNClassificationObservation: ClassificationObservation {
    var confidence: VNConfidence
    var identifier: String
}

protocol ClassificationObservation {
    var confidence: VNConfidence { get }
    var identifier: String { get }
}

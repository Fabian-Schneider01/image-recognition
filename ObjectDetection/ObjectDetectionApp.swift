//
//  ObjectDetectionApp.swift
//  ObjectDetection
//
//  Created by Fabian Schneider on 20.06.22.
//

import SwiftUI
import WikipediaKit

@main
struct ObjectDetectionApp: App {
    init() {
        WikipediaNetworking.appAuthorEmailForAPI = "inf20182@lehre.dhbw-stuttgart.de"
    }
    var body: some Scene {
        WindowGroup {
            DetectionView()
        }
    }
}

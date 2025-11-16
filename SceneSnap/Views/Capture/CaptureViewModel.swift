//
//  CaptureViewModel.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

class CaptureViewModel: ObservableObject {
    @Published var recordedVideoURL: URL?
    @Published var selectedImage: UIImage?
    @Published var isRecording: Bool = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var hasPermission: Bool = false
    
    // TODO: Implement capture methods
    func requestCameraPermission() {
        // TODO: Request camera permission
    }
    
    func startRecording() {
        isRecording = true
        // TODO: Start video recording
    }
    
    func stopRecording() {
        isRecording = false
        // TODO: Stop video recording
    }
    
    func switchCamera() {
        // TODO: Switch between front/back camera
    }
    
    func pickFromGallery() {
        // TODO: Open image picker
    }
    
    func clearMedia() {
        recordedVideoURL = nil
        selectedImage = nil
    }
}


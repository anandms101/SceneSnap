//
//  CameraView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> PreviewView {
        let previewView = PreviewView()
        previewView.videoPreviewLayer.session = session
        previewView.videoPreviewLayer.videoGravity = .resizeAspectFill
        return previewView
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {
        uiView.videoPreviewLayer.session = session
    }
    
    final class PreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            guard let layer = layer as? AVCaptureVideoPreviewLayer else {
                fatalError("Expected AVCaptureVideoPreviewLayer backed view")
            }
            return layer
        }
    }
}

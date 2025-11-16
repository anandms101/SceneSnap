//
//  PermissionManager.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation
import AVFoundation
import Photos

enum PermissionStatus {
    case authorized
    case denied
    case notDetermined
    case restricted
}

class PermissionManager {
    static let shared = PermissionManager()
    
    private init() {}
    
    // TODO: Implement permission requests
    func requestCameraPermission(completion: @escaping (PermissionStatus) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion(.authorized)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted ? .authorized : .denied)
            }
        case .denied, .restricted:
            completion(.denied)
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    func requestMicrophonePermission(completion: @escaping (PermissionStatus) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized:
            completion(.authorized)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                completion(granted ? .authorized : .denied)
            }
        case .denied, .restricted:
            completion(.denied)
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    func requestPhotoLibraryPermission(completion: @escaping (PermissionStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            completion(.authorized)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                completion(status == .authorized || status == .limited ? .authorized : .denied)
            }
        case .denied, .restricted:
            completion(.denied)
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    func checkPermissionStatus(type: PermissionType) -> PermissionStatus {
        switch type {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            return mapAVStatus(status)
        case .microphone:
            let status = AVCaptureDevice.authorizationStatus(for: .audio)
            return mapAVStatus(status)
        case .photoLibrary:
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .authorized, .limited:
                return .authorized
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            case .notDetermined:
                return .notDetermined
            @unknown default:
                return .notDetermined
            }
        }
    }
    
    private func mapAVStatus(_ status: AVAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
    }
}

enum PermissionType {
    case camera
    case microphone
    case photoLibrary
}


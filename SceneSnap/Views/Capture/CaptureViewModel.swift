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

class CaptureViewModel: NSObject, ObservableObject {
    @Published var captureSession = AVCaptureSession()
    @Published var permissionDenied: Bool = false
    @Published var selectedVideoURL: URL?
    @Published var recordedVideoURL: URL?
    @Published var isShowingVideoPicker: Bool = false
    @Published var isSessionRunning: Bool = false
    @Published var isRecording: Bool = false
    @Published var recordingDuration: TimeInterval = 0
    
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    private let sessionQueue = DispatchQueue(label: "com.scenesnap.capture.session")
    private var isConfigured = false
    private var recordingTimer: Timer?
    private let movieOutput = AVCaptureMovieFileOutput()
    private var audioInput: AVCaptureDeviceInput?
    
    override init() {
        super.init()
        captureSession.sessionPreset = .high
    }
    
    func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSessionIfNeeded()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                DispatchQueue.main.async {
                    if granted {
                        self.configureSessionIfNeeded()
                    } else {
                        self.permissionDenied = true
                    }
                }
            }
        default:
            DispatchQueue.main.async {
                self.permissionDenied = true
            }
        }
    }
    
    private func configureSessionIfNeeded() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if !self.isConfigured {
                self.setupInitialSession()
            } else {
                self.updateCameraInput(position: self.currentCameraPosition)
            }
        }
    }
    
    private func setupInitialSession() {
        captureSession.beginConfiguration()
        var configured = false
        defer {
            captureSession.commitConfiguration()
            if configured {
                startSessionIfNeeded()
            }
        }
        
        guard let device = camera(for: currentCameraPosition),
              let input = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(input) else {
            DispatchQueue.main.async {
                self.permissionDenied = true
            }
            return
        }
        
        captureSession.addInput(input)
        
        if let audioDevice = AVCaptureDevice.default(for: .audio),
           let audioInput = try? AVCaptureDeviceInput(device: audioDevice),
           captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
            self.audioInput = audioInput
        }
        
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        isConfigured = true
        configured = true
    }
    
    private func startSessionIfNeeded() {
        if !captureSession.isRunning {
            captureSession.startRunning()
            DispatchQueue.main.async {
                self.isSessionRunning = true
            }
        }
    }
    
    func switchCamera() {
        currentCameraPosition = currentCameraPosition == .back ? .front : .back
        configureSessionIfNeeded()
    }
    
    private func updateCameraInput(position: AVCaptureDevice.Position) {
        captureSession.beginConfiguration()
        captureSession.inputs.forEach { input in
            captureSession.removeInput(input)
        }
        
        if let device = camera(for: position),
           let input = try? AVCaptureDeviceInput(device: device),
           captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        if let audioInput = audioInput,
           captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }
        
        if captureSession.outputs.isEmpty, captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        captureSession.commitConfiguration()
    }
    
    private func camera(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: position
        )
        return discovery.devices.first
    }
    
    func pickFromGallery() {
        DispatchQueue.main.async {
            self.recordedVideoURL = nil
            self.isShowingVideoPicker = true
        }
    }
    
    func handlePickedVideo(url: URL) {
        DispatchQueue.main.async {
            self.recordedVideoURL = nil
            self.selectedVideoURL = url
        }
    }
    
    func startRecording() {
        guard !movieOutput.isRecording else { return }
        recordedVideoURL = nil
        selectedVideoURL = nil
        requestMicrophonePermission { [weak self] granted in
            guard let self else { return }
            guard granted else { return }
            self.sessionQueue.async {
                self.beginRecording()
            }
        }
    }
    
    private func beginRecording() {
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString).mov")
        
        if let connection = movieOutput.connection(with: .video) {
            if #available(iOS 17, *) {
                if connection.isVideoRotationAngleSupported(90) {
                    connection.videoRotationAngle = 90
                }
            } else if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
            }
        }
        
        DispatchQueue.main.async {
            self.isRecording = true
            self.recordingDuration = 0
            self.startTimer()
        }
        
        movieOutput.startRecording(to: outputURL, recordingDelegate: self)
    }
    
    func stopRecording() {
        sessionQueue.async {
            guard self.movieOutput.isRecording else { return }
            self.movieOutput.stopRecording()
        }
        DispatchQueue.main.async {
            self.isRecording = false
        }
        stopTimer()
    }
    
    func clearMedia() {
        recordedVideoURL = nil
        selectedVideoURL = nil
    }
    
    var formattedDuration: String {
        let minutes = Int(recordingDuration) / 60
        let seconds = Int(recordingDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        recordingTimer?.invalidate()
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.recordingDuration += 1
            }
        }
    }
    
    private func stopTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    private func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17, *) {
            switch AVAudioApplication.shared.recordPermission {
            case .granted:
                completion(true)
            case .denied:
                completion(false)
            case .undetermined:
                AVAudioApplication.requestRecordPermission { granted in
                    completion(granted)
                }
            @unknown default:
                completion(false)
            }
        } else {
            let audioSession = AVAudioSession.sharedInstance()
            switch audioSession.recordPermission {
            case .granted:
                completion(true)
            case .denied:
                completion(false)
            case .undetermined:
                audioSession.requestRecordPermission { granted in
                    completion(granted)
                }
            @unknown default:
                completion(false)
            }
        }
    }
}

extension CaptureViewModel: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.isRecording = false
            self.stopTimer()
            guard error == nil else {
                try? FileManager.default.removeItem(at: outputFileURL)
                return
            }
            self.recordedVideoURL = outputFileURL
            self.selectedVideoURL = outputFileURL
        }
    }
}

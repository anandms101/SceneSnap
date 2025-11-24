//
//  CaptureView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI
import UIKit
import AVKit

private enum PlaybackOverlayState {
    case hidden
    case play
    case pause
}

struct CaptureView: View {
    @StateObject private var viewModel = CaptureViewModel()
    @State private var showPostPreview: Bool = false
    @State private var overlayState: PlaybackOverlayState = .play
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 16) {
                ZStack {
                    if let recordedURL = viewModel.recordedVideoURL {
                        RecordedVideoPreview(url: recordedURL, overlayState: $overlayState)
                    } else {
                        CameraView(session: viewModel.captureSession)
                            .overlay {
                                if viewModel.permissionDenied {
                                    permissionDeniedOverlay()
                                } else if !viewModel.isSessionRunning {
                                    ProgressView("Starting camera…")
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.6))
                                        .cornerRadius(10)
                                }
                            }
                    }
                    
                    if viewModel.recordedVideoURL == nil {
                        VStack {
                            HStack {
                                Button(action: {
                                    viewModel.switchCamera()
                                }) {
                                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color.black.opacity(0.4))
                                        .clipShape(Circle())
                                }
                                .padding()
                                
                                Spacer()
                                
                                timerBadge
                                    .padding()
                            }
                            Spacer()
                        }
                    }
                }
                .frame(height: proxy.size.height - bottomSafeArea(proxy))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal)
                .padding(.top, 8)
                
                if let label = videoLabelText {
                    Text(label)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
                controlBar
                    .padding(.horizontal)
                
                Spacer(minLength: bottomSafeArea(proxy))
            }
        }
        .onChange(of: viewModel.recordedVideoURL) { _, _ in
            overlayState = .play
        }
        .task {
            viewModel.requestCameraPermission()
        }
        .sheet(isPresented: $showPostPreview) {
            PostPreviewView()
        }
        .sheet(isPresented: $viewModel.isShowingVideoPicker) {
            VideoPicker(isPresented: $viewModel.isShowingVideoPicker) { url in
                viewModel.handlePickedVideo(url: url)
            }
        }
    }
    
    private var controlBar: some View {
        HStack(spacing: 16) {
            Button(action: {
                showPostPreview = true
            }) {
                Text("Continue")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .disabled(!hasVideoAvailable)
            .opacity(hasVideoAvailable ? 1.0 : 0.6)
            
            Button(action: {
                viewModel.isRecording ? viewModel.stopRecording() : viewModel.startRecording()
            }) {
                Circle()
                    .fill(viewModel.isRecording ? Color.red : Color.white)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 4)
                    )
                    .shadow(radius: 3)
            }
            
            Button(action: {
                viewModel.pickFromGallery()
            }) {
                Text("Upload")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
        }
    }
    
    @ViewBuilder
    private func permissionDeniedOverlay() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.yellow)
            Text("Camera access needed")
                .font(.headline)
                .foregroundColor(.white)
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(12)
    }
    
    private func bottomSafeArea(_ proxy: GeometryProxy) -> CGFloat {
        proxy.safeAreaInsets.bottom + 60
    }
    
    private var timerBadge: some View {
        Text(viewModel.formattedDuration)
            .font(.caption.monospacedDigit())
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.black.opacity(0.6))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    private var hasVideoAvailable: Bool {
        viewModel.recordedVideoURL != nil || viewModel.selectedVideoURL != nil
    }
    
    private var videoLabelText: String? {
        if let recorded = viewModel.recordedVideoURL {
            return "Recorded: \(recorded.lastPathComponent)"
        }
        if let selected = viewModel.selectedVideoURL {
            return "Selected: \(selected.lastPathComponent)"
        }
        return nil
    }
}

#Preview {
    CaptureView()
}

private struct RecordedVideoPreview: View {
    let url: URL
    @Binding var overlayState: PlaybackOverlayState
    
    @State private var player: AVPlayer = AVPlayer()
    @State private var endObserver: NSObjectProtocol?
    
    var body: some View {
        VideoPlayer(player: player)
            .contentShape(Rectangle())
            .onAppear {
                preparePlayer()
            }
            .onChange(of: url) { _, _ in
                preparePlayer()
            }
            .onDisappear {
                cleanup()
            }
            .onTapGesture {
                if overlayState == .hidden {
                    player.pause()
                    overlayState = .pause
                }
            }
            .overlay(overlayView)
    }
    
    private var overlayView: some View {
        Group {
            if overlayState != .hidden {
                Button(action: handleOverlayTap) {
                    Image(systemName: overlayState == .play ? "play.fill" : "pause.fill")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white.opacity(0.85))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private func preparePlayer() {
        cleanup()
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.pause()
        overlayState = .play
        
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            overlayState = .play
        }
    }
    
    private func cleanup() {
        player.pause()
        if let observer = endObserver {
            NotificationCenter.default.removeObserver(observer)
            endObserver = nil
        }
    }
    
    private func handleOverlayTap() {
        player.play()
        overlayState = .hidden
    }
}

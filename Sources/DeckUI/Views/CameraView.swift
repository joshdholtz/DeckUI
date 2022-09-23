//
//  CameraView.swift
//  DeckUI
//
//  Created by Josh Holtz on 9/7/22.
//

import Foundation
import AVFoundation
import SwiftUI

// Taken from: https://benoitpasquier.com/webcam-utility-app-macos-swiftui/

struct Camera: View {
    @StateObject var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraContainerView(captureSession: viewModel.captureSession)
                .onAppear {
                    self.viewModel.checkAuthorization()
                }
            
            // Hack: needed to make view clickable for context menu
            // There might be a better way to do this but meh
            Rectangle()
                .fill(.white.opacity(0.001))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
            .contextMenu {
                ForEach(self.viewModel.availableDevices, id:\.self) { device in
                    Button {
                        self.viewModel.startSessionForDevice(device)
                    } label: {
                        Label(device.localizedName, systemImage: "video.fill")
                    }
                }
            }
    }
}

final class CameraView: PlatformView {

    init(captureSession: AVCaptureSession) {
        #if canImport(AppKit)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        #endif
        super.init(frame: .zero)

        #if canImport(UIKit)
        let previewLayer = layer as? AVCaptureVideoPreviewLayer
        previewLayer?.session = captureSession
        #endif

        previewLayer?.frame = self.frame
        previewLayer?.contentsGravity = .resizeAspectFill
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.automaticallyAdjustsVideoMirroring = false

        #if canImport(AppKit)
        layer = previewLayer
        #endif
    }

    @available(*, unavailable, message: "Use init(captureSession:) instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if canImport(AppKit)
    var previewLayer: AVCaptureVideoPreviewLayer?
    #elseif canImport(UIKit)
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    #endif
}

struct CameraContainerView: PlatformAgnosticViewRepresentable {

    let captureSession: AVCaptureSession

    init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
    }

    func makePlatformView(context: Context) -> CameraView {
        CameraView(captureSession: captureSession)
    }

    func updatePlatformView(_ platformView: CameraView, context: Context) {}
}

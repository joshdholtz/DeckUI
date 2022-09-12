//
//  CameraView.swift
//  DeckUI
//
//  Created by Josh Holtz on 9/7/22.
//

import Foundation
import AppKit
import AVFoundation
import SwiftUI
import Combine

// Taken from: https://benoitpasquier.com/webcam-utility-app-macos-swiftui/

struct Camera: View {
    @StateObject var viewModel = ContentViewModel()
    
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

class CameraView: NSView {
    
    var previewLayer: AVCaptureVideoPreviewLayer?

    init(captureSession: AVCaptureSession) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        super.init(frame: .zero)

        setupLayer()
    }

    func setupLayer() {

        previewLayer?.frame = self.frame
        previewLayer?.contentsGravity = .resizeAspectFill
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.connection?.automaticallyAdjustsVideoMirroring = false
        layer = previewLayer
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct CameraContainerView: NSViewRepresentable {
    typealias NSViewType = CameraView

    let captureSession: AVCaptureSession

    init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
    }

    func makeNSView(context: Context) -> CameraView {
        return CameraView(captureSession: captureSession)
    }

    func updateNSView(_ nsView: CameraView, context: Context) { }
}

class ContentViewModel: ObservableObject {

    @Published var isGranted: Bool = false
    @Published var device: AVCaptureDevice? = nil
    @Published var availableDevices = [AVCaptureDevice]()
    var captureSession: AVCaptureSession!
    private var cancellables = Set<AnyCancellable>()

    init() {
        captureSession = AVCaptureSession()
        setupBindings()
    }

    func setupBindings() {
        $isGranted
            .sink { [weak self] isGranted in
                if isGranted {
                    self?.prepareCamera()
                } else {
                    self?.stopSession()
                }
            }
            .store(in: &cancellables)
    }

    func fetchDevices() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [
            .builtInMicrophone,
            .builtInWideAngleCamera,
            .externalUnknown
        ], mediaType: .video, position: .unspecified)
        self.availableDevices = discoverySession.devices
    }
    
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.isGranted = true

            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    if granted {
                        DispatchQueue.main.async {
                            self?.isGranted = granted
                        }
                    }
                }

            case .denied: // The user has previously denied access.
                self.isGranted = false
                return

            case .restricted: // The user can't grant access due to restrictions.
                self.isGranted = false
                return
        @unknown default:
            fatalError()
        }
    }

    func startSession() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }

    func stopSession() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }

    func prepareCamera() {
        captureSession.sessionPreset = .high
        
        if let device = AVCaptureDevice.default(for: .video) {
            startSessionForDevice(device)
        }
        
        self.fetchDevices()
    }

    func startSessionForDevice(_ device: AVCaptureDevice) {
        do {
            for input in captureSession.inputs {
                captureSession.removeInput(input)
            }

            let input = try AVCaptureDeviceInput(device: device)
            captureSession.beginConfiguration()
            addInput(input)
            captureSession.commitConfiguration()
            startSession()
            self.device = device
        }
        catch {
            print("Something went wrong - ", error.localizedDescription)
        }
    }

    func addInput(_ input: AVCaptureInput) {
        guard captureSession.canAddInput(input) == true else {
            return
        }
        captureSession.addInput(input)
    }
}

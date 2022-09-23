//
//  CameraViewModel.swift
//  DeckUI
//
//  Created by Alexandr Goncharov on 23.09.2022.
//

import Foundation
import AVFoundation
import Combine

final class CameraViewModel: ObservableObject {

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
        var deviceTypes: [AVCaptureDevice.DeviceType] = [
            .builtInMicrophone,
            .builtInWideAngleCamera,
        ]
#if os(macOS)
        deviceTypes.append(.externalUnknown)
#endif
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: .unspecified
        )
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

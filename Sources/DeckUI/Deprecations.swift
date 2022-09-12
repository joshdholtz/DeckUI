//
//  Deprecations.swift
//  DeckUI
//
//  Created by Josh Holtz on 9/11/22.
//

import Foundation

public extension Presenter {

    @available(iOS, deprecated: 1, renamed: "init(deck:slideTransition:loop:defaultResolution:showCamera:cameraConfig:)")
    @available(tvOS, deprecated: 1, renamed: "init(deck:slideTransition:loop:defaultResolution:showCamera:cameraConfig:)")
    @available(watchOS, deprecated: 1, renamed: "init(deck:slideTransition:loop:defaultResolution:showCamera:cameraConfig:)")
    @available(macOS, deprecated: 1, renamed: "init(deck:slideTransition:loop:defaultResolution:showCamera:cameraConfig:)")
    @available(macCatalyst, deprecated: 1, renamed: "init(deck:slideTransition:loop:defaultResolution:showCamera:cameraConfig:)")
    init(deck: Deck, slideDirection: SlideTransition, loop: Bool = false, defaultResolution: DefaultResolution = (width: 1920, height: 1080), showCamera: Bool = false, cameraConfig: CameraConfig = CameraConfig()) {
        self = Presenter(deck: deck, slideTransition: slideDirection, loop: loop, defaultResolution: defaultResolution, showCamera: showCamera, cameraConfig: cameraConfig)
    }
    
}

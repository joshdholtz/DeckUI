//
//  Presenter.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Presenter: View {
    public typealias DefaultResolution = (width: Double, height: Double)
    
    @ObservedObject private var presentationState = PresentationState.shared

    let deck: Deck
    let defaultResolution: DefaultResolution
    let showCamera: Bool
    let fillScreen: Bool
    let cameraConfig: CameraConfig
    
    @State var isFullScreen = false
    
    public init(deck: Deck, slideTransition: SlideTransition? = .horizontal, loop: Bool = false, defaultResolution: DefaultResolution = (width: 1920, height: 1080), showCamera: Bool = false, cameraConfig: CameraConfig = CameraConfig(), fillScreen: Bool = false) {

        self.deck = deck
        self.defaultResolution = defaultResolution
        self.showCamera = showCamera
        self.cameraConfig = cameraConfig
        self.fillScreen = fillScreen
        self.presentationState.deck = deck
        self.presentationState.loop = loop
        self.presentationState.slideTransition = slideTransition
    }
    
    // If we can turn this into an environment variable or observable object, presenter notes and potentially controls become way easier?
    var slide: Slide? {
        let slides = self.deck.slides()
        if slides.count > presentationState.slideIndex {
            return slides[presentationState.slideIndex]
        } else {
            return nil
        }
    }

    func frameSize(_ width: Double, _ height: Double) -> CGSize {
        if fillScreen {
            let scaleAmount = scaleAmount(width, height)
            return CGSize(
                width: max(defaultResolution.width, width / scaleAmount),
                height: max(defaultResolution.height, height / scaleAmount)
            )
        } else {
            return CGSize(width: defaultResolution.width, height: defaultResolution.height)
        }
    }
    
    func scaleAmount(_ width: Double, _ height: Double) -> Double {
        let widthScale = width / self.defaultResolution.width
        let heightScale = height / self.defaultResolution.height
        
        let defaultResolution = self.defaultResolution.width / self.defaultResolution.height
        let frameResolution = width / height
        
        if defaultResolution < frameResolution {
            return heightScale
        } else {
            return widthScale
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let size = frameSize(proxy.size.width, proxy.size.height)
            ZStack(alignment: .center) {
                (slide?.theme ?? deck.theme).background
                
                self.bodyContents
                    .clipped()
                    .frame(
                        width: size.width,
                        height: size.height,
                        alignment: .center)
                    .scaleEffect(self.scaleAmount(proxy.size.width, proxy.size.height), anchor: .center)

                if self.showCamera {
                    ZStack(alignment: cameraConfig.alignment) {
                        Camera()
                            .frame(width: cameraConfig.size, height: cameraConfig.size)
                            .clipShape(Circle())
                            .padding(cameraConfig.padding)
                        
                        Color.clear // Make full width and height
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .scaleEffect(self.scaleAmount(proxy.size.width, proxy.size.height), anchor: .center)
                }
            }.frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
        }
    }
    
    private var bodyContents: some View {
        ZStack {
            if self.isFullScreen {
                VStack {
                    SlideNavigationToolbarButtons()
                }.opacity(0)
            }
            
            ForEach(Array(self.deck.slides().enumerated()), id: \.offset) { index, slide in
                
                if index == presentationState.slideIndex {
                    slide.buildView(theme: self.deck.theme)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .zIndex(Double(presentationState.slideIndex))
                }
            }.transition(presentationState.activeTransition)
        }
        .navigationTitle(self.deck.title)
        #if canImport(AppKit)
        .if(!self.isFullScreen) {
            $0.toolbar {
                ToolbarItemGroup {
                    SlideNavigationToolbarButtons()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willEnterFullScreenNotification)) { _ in
            self.isFullScreen = true
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willExitFullScreenNotification)) { _ in
            self.isFullScreen = false
        }
        #elseif canImport(UIKit)
        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                let tolerance: ClosedRange<CGFloat> = -100...100
                switch(value.translation.width, value.translation.height) {
                case (tolerance, ...0):  NotificationCenter.default.post(name: .keyUp, object: nil)
                case (tolerance, 0...):  NotificationCenter.default.post(name: .keyDown, object: nil)
                case (...0, tolerance):  presentationState.nextSlide()
                case (0..., tolerance):  presentationState.previousSlide()
                default:  break
                }
            }
        )
        #endif
    }
    

}

public enum SlideTransition {
    case horizontal, vertical
}

extension Optional where Wrapped == SlideTransition {
    var next: AnyTransition {
        switch self {
        case .horizontal:
            return .slideFromTrailing
        case .vertical:
            return .slideFromBottom
        case .none:
            return .identity
        }
    }
    
    var previous: AnyTransition {
        switch self {
        case .horizontal:
            return .slideFromLeading
        case .vertical:
            return .slideFromTop
        case .none:
            return .identity
        }
    }
}

public struct CameraConfig {
    let size: CGFloat
    let padding: CGFloat
    let alignment: Alignment
    
    public init(size: CGFloat = 300, padding: CGFloat = 40, alignment: Alignment = .bottomTrailing) {
        self.size = size
        self.padding = padding
        self.alignment = alignment
    }
}

extension AnyTransition {
    static var slideFromBottom: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .top))
        
    }
    
    static var slideFromTop: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .top),
            removal: .move(edge: .bottom))
        
    }
    
    static var slideFromTrailing: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))
        
    }
    
    static var slideFromLeading: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .trailing))
        
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

extension NSNotification.Name {
    static let keyUp = NSNotification.Name("presenter_pressed_up")
    static let keyDown = NSNotification.Name("presenter_pressed_down")
    static let slideChanged = NSNotification.Name("slide_changed")
}

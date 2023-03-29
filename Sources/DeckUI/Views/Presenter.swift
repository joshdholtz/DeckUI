//
//  Presenter.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Presenter: View {
    public typealias DefaultResolution = (width: Double, height: Double)
    
    let deck: Deck
    let slideTransition: SlideTransition?
    let loop: Bool
    let defaultResolution: DefaultResolution
    let showCamera: Bool
    let fillScreen: Bool
    let cameraConfig: CameraConfig
    
    @State var index = 0
    @State var isFullScreen = false
    @State var activeTransition: AnyTransition = .slideFromTrailing
    
    public init(deck: Deck, slideTransition: SlideTransition? = .horizontal, loop: Bool = false, defaultResolution: DefaultResolution = (width: 1920, height: 1080), showCamera: Bool = false, cameraConfig: CameraConfig = CameraConfig(), fillScreen: Bool = false) {
        self.deck = deck
        self.slideTransition = slideTransition
        self.loop = loop
        self.defaultResolution = defaultResolution
        self.showCamera = showCamera
        self.cameraConfig = cameraConfig
        self.fillScreen = fillScreen
    }
    
    var slide: Slide? {
        let slides = self.deck.slides()
        if slides.count > index {
            return slides[index]
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
                    self.toolbarButtons
                }.opacity(0)
            }
            
            ForEach(Array(self.deck.slides().enumerated()), id: \.offset) { index, slide in
                
                if index == self.index {
                    slide.buildView(theme: self.deck.theme)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .zIndex(Double(self.index))
                }
            }.transition(self.activeTransition)
        }
        .navigationTitle(self.deck.title)
        #if canImport(AppKit)
        .if(!self.isFullScreen) {
            $0.toolbar {
                ToolbarItemGroup {
                    self.toolbarButtons
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
                case (tolerance, ...0):  lineUp()
                case (tolerance, 0...):  lineDown()
                case (...0, tolerance):  nextSlide()
                case (0..., tolerance):  previousSlide()
                default:  break
                }
            }
        )
        #endif
    }
    
    var toolbarButtons: some View {
        Group {
            Button {
                withAnimation {
                    self.previousSlide()
                }
            } label: {
                Label("Previous", systemImage: "arrow.left")
            }.keyboardShortcut(.leftArrow, modifiers: [])
            
            Button {
                withAnimation {
                    self.nextSlide()
                }
            } label: {
                Label("Next", systemImage: "arrow.right")
            }.keyboardShortcut(.rightArrow, modifiers: [])
            
            Button {
                lineDown()

            } label: {
                Label("Down", systemImage: "arrow.down")
            }.keyboardShortcut(.downArrow, modifiers: [])
            
            Button {
                lineUp()
            } label: {
                Label("Up", systemImage: "arrow.up")
            }.keyboardShortcut(.upArrow, modifiers: [])
        }
    }

    private func lineUp() {
        NotificationCenter.default.post(name: .keyUp, object: nil)
    }

    private func lineDown() {
        NotificationCenter.default.post(name: .keyDown, object: nil)
    }
    
    private func nextSlide() {
        let slides = self.deck.slides()
        if self.index >= (slides.count - 1) {
            if self.loop {
                self.index = 0
            }
        } else {
            self.index += 1
        }
        
        let nextSlide = slides[self.index]
        
        self.activeTransition = (nextSlide.transition ?? self.slideTransition).next
    }
    
    private func previousSlide() {
        let slides = self.deck.slides()

        let currSlide = slides[self.index]
        
        if self.index <= 0 {
            if self.loop {
                self.index = slides.count - 1
            }
        } else {
            self.index -= 1
        }

        self.activeTransition = (currSlide.transition ?? self.slideTransition).previous
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
}

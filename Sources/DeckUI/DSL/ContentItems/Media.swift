//
//  Media.swift
//  DeckUI
//
//  Created by Josh Holtz on 9/1/22.
//

import SwiftUI
import AVFoundation
import Foundation
import AVKit

public struct Media: ContentItem {
    public enum VideoSource {
        case bundle(name: String)
    }

    public struct VideoOptions {
        let autoplay: Bool
    }

    public enum Kind {
        case remoteImage(URL), assetImage(String), bundleImage(String)
        case video(source: VideoSource, options: VideoOptions)

        public static func bundleVideo(_ name: String, autoplay: Bool = true) -> Kind {
            .video(source: .bundle(name: name), options: .init(autoplay: autoplay))
        }

        
        var view: some View {
            Group {
                switch self {
                case .remoteImage(let url):
                    // TODO: This loads really weird with the slide transition
                    AsyncImage(
                        url: url,
                        content: { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                case .assetImage(let name):
                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .bundleImage(let name):
                    #if canImport(AppKit)
                    let platformImage = PlatformImage(named: name)
                    #elseif canImport(UIKit)
                    let path = Bundle.main.path(forResource: name, ofType: nil)!
                    let platformImage = PlatformImage(contentsOfFile: path)
                    #endif
                    Image(platformImage: platformImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case let .video(.bundle(name), options):
                    let url = Bundle.main.url(forResource: name, withExtension: nil)!
                    let player = AVPlayer(url: url)
                    VideoPlayer(player: player)
                        .onAppear {
                            if options.autoplay {
                                player.play()
                            }
                        }
                }
            }
        }
    }
    
    public let id = UUID()
    let kind: Kind
    
    public init(_ kind: Kind) {
        self.kind = kind
    }
    
    // TODO: Use theme
    public func buildView(theme: Theme) -> AnyView {
        AnyView(
            self.kind.view
        )
    }
}

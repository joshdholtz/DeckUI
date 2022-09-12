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
    public enum Kind {
        case remoteImage(URL), assetImage(String), bundleImage(String)
        case bundleVideo(String)
        
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
                case .bundleVideo(let name):
                    let url = Bundle.main.url(forResource: name, withExtension: nil)!
                    let player = AVPlayer(url: url)
                    VideoPlayer(player: player).task {
                        await player.play()
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

//
//  Media.swift
//  DeckUI
//
//  Created by Josh Holtz on 9/1/22.
//

import SwiftUI
import AppKit

public struct Media: ContentItem {
    public enum Kind {
        case remoteImage(URL), assetImage(String), bundleImage(String)
        
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
                    Image(nsImage: NSImage(named: name)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
    
    public let id = UUID()
    let kind: Kind
    
    public init(_ kind: Kind) {
        self.kind = kind
    }
    
    @ViewBuilder
    public var view: AnyView {
        AnyView(
            self.kind.view
        )
    }
}

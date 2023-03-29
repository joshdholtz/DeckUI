//
//  Deck+Rendering.swift
//  
//
//  Created by Morten Bek Ditlevsen on 26/03/2023.
//

import Foundation
import SwiftUI

struct IsRenderingPDFKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var isRenderingPDF: Bool {
        get { self[IsRenderingPDFKey.self] }
        set { self[IsRenderingPDFKey.self] = newValue }
    }
}

extension Deck {
    @MainActor
    @available(macOS 13.0, *)
    public func render(size: CGSize,
                       rasterizationScale: CGFloat = 2,
                       url: URL = .documentsDirectory.appending(path: "output.pdf")) -> URL {

        var box = CGRect(origin: .zero, size: size)

        guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
            return url
        }

        for slide in self.slides() {
            let renderer = ImageRenderer(content:
                slide.buildView(theme: self.theme)
                    .environment(\.isRenderingPDF, true)
                    .frame(width: size.width,
                           height: size.height)
                    .preferredColorScheme(.dark)
                    .colorScheme(.dark)
            )
            renderer.render(rasterizationScale: rasterizationScale) { size, context in
                pdf.beginPDFPage(nil)
                context(pdf)
                pdf.endPDFPage()
            }
        }
        pdf.closePDF()
        return url
    }
}

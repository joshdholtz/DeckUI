//
//  File.swift
//  
//
//  Created by Danny North on 5/2/23.
//

import SwiftUI

extension ContentItem {
    
    public func theme(_ newTheme: Theme) -> some ContentItem {
        ThemeWritingContentItem(content: self, modifier: { theme in
            theme.merge(newTheme)
        })
    }
    
    public func theme<Value>(_ keyPath: WritableKeyPath<Theme, Value>, _ value: Value) -> some ContentItem {
        ThemeWritingContentItem(content: self, modifier: { theme in
            theme[keyPath: keyPath] = value
        })
    }
    
}

private struct ThemeWritingContentItem: ContentItem {
    let id = UUID()
    
    let content: any ContentItem
    let modifier: (inout Theme) -> Void
    
    func buildView(theme: Theme) -> AnyView {
        var modified = theme
        modifier(&modified)
        
        return content.buildView(theme: modified)
    }
    
}

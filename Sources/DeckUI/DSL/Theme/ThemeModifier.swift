//
//  File.swift
//  
//
//  Created by Danny North on 5/2/23.
//

import SwiftUI

extension ContentItem {
    
    public func theme<Value>(_ keyPath: WritableKeyPath<Theme, Value>, _ value: Value) -> some ContentItem {
        ThemeWritingContentItem(keyPath: keyPath, value: value, content: self)
    }
    
}

private struct ThemeWritingContentItem<Value>: ContentItem {
    let id = UUID()
    
    let keyPath: WritableKeyPath<Theme, Value>
    let value: Value
    
    let content: any ContentItem
    
    func buildView(theme: Theme) -> AnyView {
        var modified = theme
        modified[keyPath: keyPath] = value
        
        return content.buildView(theme: modified)
    }
    
}

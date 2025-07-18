# DeckUI Project Rules for Claude

## Project Overview
DeckUI is a Swift DSL for creating slide decks/presentations entirely in Swift code within Xcode. It uses SwiftUI and supports macOS 12+ and iOS 15+.

## Core Development Rules

### 1. Swift & SwiftUI Conventions
- Use Swift 5.6+ features and syntax
- Follow SwiftUI best practices and patterns
- Maintain cross-platform compatibility (macOS and iOS)
- Use `Compatibility.swift` for platform-specific code

### 2. DSL Pattern Rules
- Always use `@resultBuilder` for DSL components
- Maintain consistency with existing DSL syntax patterns
- New content items must:
  - Conform to `ContentItem` protocol
  - Have unique IDs for SwiftUI's ForEach
  - Support theme customization where applicable
  - Follow the pattern established in existing content items

### 3. File Organization
- Place DSL components in `Sources/DeckUI/DSL/`
- Content items go in `Sources/DeckUI/DSL/ContentItems/`
- View components go in `Sources/DeckUI/Views/`
- Platform-specific code goes in `Compatibility.swift`

### 4. Theme System
- All visual components should respect the theme system
- Use theme colors (foreground, background, accent) consistently
- Allow theme overrides at the slide level
- Maintain compatibility with existing themes (dark, black, white)

### 5. Testing & Examples
- Update the Demo app when adding new features
- Test on both macOS and iOS platforms
- Ensure Xcode preview functionality works
- Test with different themes

### 6. Code Style
- Match existing code style and formatting
- Use descriptive names following Swift naming conventions
- Keep DSL syntax clean and intuitive
- Avoid unnecessary comments (code should be self-documenting)

### 7. Feature Implementation
- New features should integrate seamlessly with existing DSL
- Maintain backward compatibility
- Consider both platforms when implementing features
- Update result builders to support new content types

### 8. Navigation & Interaction
- Respect existing keyboard shortcuts (arrow keys, up/down)
- Maintain gesture support on iOS
- Ensure new interactive elements don't conflict with navigation

### 9. Performance Considerations
- Use SwiftUI's built-in optimization features
- Avoid unnecessary re-renders
- Keep slide transitions smooth
- Optimize media loading and display

### 10. Dependencies
- Minimize external dependencies
- Only Splash is currently used for syntax highlighting
- Any new dependencies must be justified and added via Swift Package Manager

## Build & Test Commands
- Build: `swift build`
- Test: `swift test`
- Run Demo: Open `Examples/Demo/Demo.xcodeproj` in Xcode

## Common Tasks
- Adding new content type: Create in `ContentItems/`, conform to `ContentItem`, update builders
- Adding new theme: Update `Theme.swift`, test with all content types
- Platform-specific features: Use `Compatibility.swift` for abstraction
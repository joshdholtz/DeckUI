# DeckUI

DeckUI is a Swift DSL (domain specific language) for writing slide decks in Xcode. It allows for quick creation of  slides and content in a language and environment you are familiar with.

But _why_? 

Well, I made this because:
- I was bored on an airplane
- Wanted to use this as a demo for future conference talk on Swift DSLs
- Need something more customizable than markdown for writing slide decks and more codey than Keynote

👉 Watch [Introducing DeckUI - Write slide decks in Swift](https://www.youtube.com/watch?v=FraeH6OeJPY) on my YouTube channel

## ✨ Features

- [x] Create slide decks in pure Swift code
- [x] Decks are presented in SwiftUI with `Presenter`
- [x] Build decks without knowing any SwiftUI
  - With `Deck`, `Slide`, `Title`, `Words`, `Bullets`, `Media`, `Columns`
- [x] Use `RawView` to drop any SwiftUI view
  - Fully interactable and great for demos
- [x] Display code with `Code`
  - Use up and down arrows to highlight lines of code as your talking about them

### 🐌 Future Features

- [ ] Support iOS and maybe tvOS
- [ ] Animations within a slide
- [ ] Support videos on `Media`
- [ ] More customization on `Words`
- [ ] Nesting of `Bullets`
- [ ] Syntax highlighting for `Code`
- [ ] Documentation
- [ ] More examples

```swift
import SwiftUI
import DeckUI

struct ContentView: View {
    var body: some View {
        Presenter(deck: self.deck)
    }
}

extension ContentView {
    var deck: Deck {
        Deck(title: "SomeConf 2023") {
            Slide(alignment: .center) {
                Title("Welcome to DeckUI")
            }

            Slide {
                Title("Slide 1")
                Words("Some useful content")
            }
        }
    }
}
```

## 💻 Installing

### Swift Package Manager

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/joshdholtz/DeckUI.git`
- Select "Up to Next Major" with "1.0.0"

## 🚀 Getting Started

There are no official "Getting Started" docs yet 😅 But look at...

- [Demo app](https://github.com/joshdholtz/DeckUI/blob/main/Examples/Demo/Shared/ContentView.swift) for usage
- [Sources/DeckUI/DSL](https://github.com/joshdholtz/DeckUI/tree/main/Sources/DeckUI/DSL) for how the `Deck`, `Slide`, and all slide components are built
- [Sources/DeckUI/Views](https://github.com/joshdholtz/DeckUI/tree/main/Sources/DeckUI/Views) for how `Presenter` is built

## 📖 Documentation

100% not documented yet but I'll get there 🤷‍♂️

## 🏎 Performance

Probably bad and never production ready 😈 Please only use DeckUI for a single presentation and never at any scale.

## 👨‍💻 Contributing

Yes please! I'm happy to discuss issues and review/merge pull requests 🙂 I will do my best to get to the but I am a dad, work at [RevenueCat](https://www.revenuecat.com/), and the lead maintainer of [fastlane](https://github.com/fastlane/fastlane) so I might not respond right away.

## 📚 Examples

### Slide

```swift
Slide {
    // Content
}
```

```swift
Slide(alignment: .center, padding: 80, theme: .white) {
    // Content
}
```

### Title

```swift
Slide(alignment: .center) {
    Title("Introducing...")
}
```

```swift
Slide {
    Title("Introduction", subtitle: "What is it?")
    // Content
}
```

### Words

```swift
Slide(alignment: .center) {
    Title("Center alignment")
    Words("Slides can be center aligned")
    Words("And more words")
}
```

### Bullets

```swift
Slide {
    Title("Introduction", subtitle: "What is it?")
    Bullets {
        Words("A custom Swift DSL to make slide decks")
        Words("Distributed as a Swift Package")
        Words("Develop your slide deck in Xcode with Swift")
    }
}
```

```swift
Slide {
    Title("Introduction", subtitle: "What is it?")
    Bullets(style: .dash) {
        Words("A custom Swift DSL to make slide decks")
        Words("Distributed as a Swift Package")
        Words("Develop your slide deck in Xcode with Swift")
    }
}
```

### Media

```swift
Slide {
    Media(.assetImage("some-asset-name"))
    Media(.bundleImage("some-file-name.jpg"))
    Media(.remoteImage(URL(string: "http://placekitten.com/g/200/300"))!)
}
```

### Columns

```swift
Slide {
    Title("Columns")
    Columns {
        Column {
            // Content
        }
        
        Column {
            // Content
        }
    }
}
```

```swift
Slide {
    Title("Columns")
    Columns {
        Column {
            // Content
        }
        
        Column {
            // Content
        }

        Column {
            // Content
        }

        Column {
            // Content
        }
    }
}
```

### Code

```swift
Slide {
    Code("""
    struct ContentView: View {
        var body: some View {
            Text("Hello slides")
        }
    }
    """)
}
```

```swift
Slide {
    Code("""
    struct ContentView: View {
        var body: some View {
            Text("Hello slides")
        }
    }
    """, , enableHighlight: false)
}
```

### RawView

```swift
Slide {
    RawView {
        CounterView()
    }
}

struct CounterView: View {
    @State var count = 0
    
    var body: some View {
        Button {
            self.count += 1
        } label: {
            Text("Press me - \(self.count)")
                .font(.system(size: 60))
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white, lineWidth: 2)
                )
        }.buttonStyle(.plain)
    }
}
```

### Themes

```swift
struct ContentView: View {
    var body: some View {
        Presenter(deck: self.deck, showCamera: true)
    }
}

extension Theme {
    public static let venonat: Theme = Theme(
        background: Color(hex: "#624a7b"),
        title: Foreground(
            color: Color(hex: "#ff5a5a"),
            font: Font.system(size: 80,
                              weight: .bold,
                              design: .default)
        ),
        subtitle: Foreground(
            color: Color(hex: "#a48bbd"),
            font: Font.system(size: 50,
                              weight: .light,
                              design: .default).italic()
        ),
        body: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 50,
                              weight: .regular,
                              design: .default)
        ),
        code: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 26,
                              weight: .regular,
                              design: .monospaced)
        ),
        codeHighlighted: (Color(hex: "#312952"), Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 26,
                              weight: .heavy,
                              design: .monospaced)
        ))
    )
}
```
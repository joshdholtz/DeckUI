//
//  ContentView.swift
//  Shared
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI
import DeckUI

struct ContentView: View {
    var body: some View {
        Presenter(deck: self.deck, showCamera: true)
    }
}

extension ContentView {
    var deck: Deck {
        Deck(title: "DeckUI Demo") {
            Slide(alignment: .center) {
                Title("Introducing...")
            }
            
            Slide(alignment: .center) {
                RawView {
                    Text("DeckUI")
                        .font(.system(size: 200, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(60)
                        .border(.white.opacity(0.5), width: 20)
                }
            }
            
            Slide {
                Title("Introduction", subtitle: "What is it?")
                Bullets(style: .bullet) {
                    Words("A custom Swift DSL to make slide decks")
                    Words("Distributed as a Swift Package")
                    Words("Develop your slide deck in Xcode with Swift")
                }
            }
            
            Slide(alignment: .center) {
                Title("But why?")
            }
            
            Slide {
                Title("But why?", subtitle: "Because I can")
                Bullets(style: .bullet) {
                    Words("Bored on a plane ride")
                    Words("Future talk on writing Swift DSLs")
                    Words("Markdown 👉 Swift 👈 Keynote")
                }
            }
            
            Slide(alignment: .center) {
                Title("What's all possible?")
            }

            Slide(alignment: .center) {
                Title("Center alignment")
                Words("Slides can be center aligned")
            }

            Slide(alignment: .top) {
                Title("Top alignment")
                Words("Slides also be top aligned")
            }
            
            Slide {
                Title("Images")
                Media(.bundleImage("bill-murray.jpeg"))
            }
            
            Slide {
                Title("Videos")
                Media(.bundleVideo("big-buck-bunny.mp4"))
            }
            
            Slide {
                Title("Multiple Columns", subtitle: "1, 2, or more")
                
                Columns {
                    Column {
                        Bullets(style: .bullet) {
                            Words("Bill")
                            Words("Murray")
                            Words("Image")
                            Words("👉")
                        }
                    }
                    
                    Column {
                        Media(.assetImage("murray"))
                    }
                }
            }
            
            Slide {
                Title("3 Bill Muarries", subtitle: "Don't know the plural of  Murray")
                
                Columns {
                    Column {
                        Media(.assetImage("murray"))
                    }
                    
                    Column {
                        Media(.assetImage("murray"))
                    }
                    
                    Column {
                        Media(.assetImage("murray"))
                    }
                }
            }
            
            Slide {
                Title("Code Blocks", subtitle: "")
                Columns {
                    Column {
                        Code("""
                        struct CounterView: View {
                            @State var count = 0
                            
                            var body: some View {
                                Button {
                                    self.count += 1
                                } label: {
                                    Text("Press me - \\(self.count)")
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
                        """)
                    }
                    Column {
                        Bullets {
                            Words("Press up and down arrows")
                            Words("You can highlight lines")
                        }
                    }
                }
            }

            Slide {
                Title("Drop in any SwiftUI view", subtitle: "Do anything you want")
                
                Columns {
                    Column {
                        RawView {
                            CounterView()
                        }
                    }

                    Column {
                        Code("""
                        struct CounterView: View {
                            @State var count = 0
                            
                            var body: some View {
                                Button {
                                    self.count += 1
                                } label: {
                                    Text("Press me - \\(self.count)")
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
                        """)
                    }
                }
            }
            
            Slide(alignment: .center) {
                Title("Quick tutorial")
            }

            Slide {
                Title("Make Deck like...", subtitle: "Super simple")
                Columns {
                    Column {
                        Code("""
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
                        """)
                    }
                    
                    Column {
                        Bullets(style: .bullet) {
                            Words("Create a `Deck` with multiple `Slide` ")
                            Words("Create `Presenter` and give a deck")
                            Words("`Presenter` is a SwiftUI to present a `Deck`")
                        }
                    }
                }
            }
            
            Slide(theme: .venonat) {
                Title("Change theme", subtitle: "On Deck or Slide")
                Columns {
                    Column {
                        Code("""
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
                        """)
                    }
                    
                    Column {
                        Code("""
                        // Set theme on presenter
                        var body: some View {
                            Presenter(deck: self.deck, theme: .venonat)
                        }

                        // Or on individual slide
                        Slide(theme: .venonat) {
                            Title("Some slide")
                        }
                        """, enableHighlight: false)
                    }
                }
            }
            
            Slide {
                Title("Bullets", subtitle: "")
                Columns {
                    Column {
                        Code("""
                        Slide {
                            Bullets {
                                Words("")
                                Words("")
                                Words("")
                            }
                            
                            Bullets(style: .dash) {
                                Words("")
                                Words("")
                                Words("")
                            }
                        }
                        """)
                    }
                    
                    Column {
                        Bullets {
                            Words("Bullets take `Words`")
                            Words("Default to circle/bullet")
                            Words("Can change style")
                        }
                    }
                }
            }

            Slide {
                Title("Media", subtitle: "")
                Columns {
                    Column {
                        Code("""
                        Slide {
                            Media(.assetImage(""))
                            Media(.bundleImage(""))
                            Media(.remoteImage(URL(string: ""))!)
                        }
                        """)
                    }
                    
                    Column {
                        Bullets {
                            Words("Three media types")
                            Words("Currently all images")
                            Words("Video coming soon")
                        }
                    }
                }
            }

            Slide {
                Title("Columns", subtitle: "")
                Columns {
                    Column {
                        Code("""
                        Slide {
                            Code(\"\"\"
                            Columns {
                                Column {
                                    Bullets {
                                        Words("Left")
                                        Words("is")
                                        Words("cool")
                                    }
                                }
                                Column {
                                    Bullets {
                                        Words("Right")
                                        Words("is")
                                        Words("cooler")
                                    }
                                }
                            }
                            \"\"\")
                        }
                        """)
                    }
                    
                    Column {
                        Bullets {
                            Words("Split slide into 1 to many columns")
                            Words("No more explaination needed")
                        }
                    }
                }
            }

            Slide {
                Title("Code", subtitle: "")
                Columns {
                    Column {
                        Code("""
                        Slide {
                            Code(\"\"\"
                            Columns {
                                Column {
                                    Bullets {
                                        Words("Left")
                                        Words("is")
                                        Words("cool")
                                    }
                                }
                                Column {
                                    Bullets {
                                        Words("Right")
                                        Words("is")
                                        Words("cooler")
                                    }
                                }
                            }
                            \"\"\")
                        }
                        """)
                    }
                    
                    Column {
                        Bullets {
                            Words("Easily drop in any code")
                            Words("Up and down highlight lines")
                            Words("Syntax highlight (eventually)")
                        }
                    }
                }
            }

            Slide {
                Title("RawView", subtitle: "Power is all yours")
                Columns {
                    Column {
                        Code("""
                            Slide(alignment: .center) {
                                RawView {
                                    Text("DeckUI")
                                        .font(.system(size: 200, weight: .bold, design: .monospaced))
                                        .foregroundColor(.white)
                                        .padding(60)
                                        .border(.white.opacity(0.5), width: 20)
                                }
                            }
                        """)
                    }
                    
                    Column {
                        Bullets {
                            Words("Put any SwiftUI view in `RawView`")
                            Words("Native view or custom view")
                            Words("Great for showing SwiftUI, WeatherKit, or any API or SDK examples")
                        }
                    }
                }
            }
            
            Slide(alignment: .center) {
                RawView {
                    Text("https://github.com/joshdholtz/deckui")
                        .underline()
                        .font(.system(size: 60, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
        }
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

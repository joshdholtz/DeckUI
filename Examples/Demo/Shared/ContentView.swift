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
        Presenter(deck: self.deck)
    }
}

extension ContentView {
    var deck: Deck {
        Deck(title: "DeckUI Demo", theme: .venonat) {
            Slide(alignment: .center) {
                Title("Welcome to DeckUI")
            }
            
            Slide {
                Title("Introduction", subtitle: "What is it?")
                Columns {
                    Column {
                        Bullets(style: .bullet) {
                            Words("A Swift DSL used to make slides")
                            Words("This is made for a future talk")
                            Words("Probably never production ready")
                        }
                    }
                    Column {
                        Words("👈 So cool")
                    }
                }
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
                Media(.bundleImage("bill-murray"))
            }
            
            Slide {
                Title("Multiple Columns")
                
                Columns {
                    Column {
                        Bullets(style: .bullet) {
                            Words("Left")
                            Words("Twix")
                            Words("Is")
                            Words("Better")
                        }
                    }
                    
                    Column {
                        Code("""
                        Slide {
                            Title("Introduction")
                            Columns {
                                Column {
                                    Words("- Super")
                                    Words("- Duper")
                                    Words("- Cool")
                                }
                                Column {
                                    Words("👈 So cool")
                                }
                            }
                        }
                        """)
                    }
                }
            }

            Slide {
                Title("Drop in any SwiftUI view")
                
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

            Slide {
                Title("Make Deck like...")
                Columns {
                    Column {
                        Words("Scroll to see all the code...")
                        
                        Code("""
                        Deck(title: "SomeConf 2023") {
                            Slide(alignment: .center) {
                                Title("Welcome to DeckUI")
                            }

                            Slide {
                                Title("Introduction", subtitle: "What is it?")
                                Columns {
                                    Column {
                                        Words("- A Swift DSL used to make slides")
                                        Words("- This is made for a future talk")
                                        Words("- Probably never production ready")
                                    }
                                    Column {
                                        Words("👈 So cool")
                                    }
                                }
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
                                Title("Drop in any SwiftUI view")
                                RawView {
                                    CounterView()
                                }
                            }
                        }
                        """)
                    }
                }
            }
            
            Slide {
                Title("Present like...")
                
                Code("""
                import SwiftUI
                import DeckUI
                
                struct ContentView: View {
                    var body: some View {
                        Presenter(deck: self.deck)
                
                        // or Presenter(deck: self.deck, slideDirection: .vertical, loop: true)
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
        }
    }
}

extension Theme {
    public static let venonat: Theme = Theme(
        background: Color(hex: "#624a7b"),
        title: Foreground(
            color: Color(hex: "#ff5a5a"),
            font: Font.system(size: 80, weight: .bold, design: .default)
        ),
        subtitle: Foreground(
            color: Color(hex: "#a48bbd"),
            font: Font.system(size: 50, weight: .light, design: .default).italic()
        ),
        body: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 50, weight: .regular, design: .default)
        ),
        code: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 26, weight: .regular, design: .monospaced)
        ),
        codeHighlighted: (Color(hex: "#312952"), Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 26, weight: .heavy, design: .monospaced)
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

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
        Deck(title: "SomeConf 2023") {
            Slide(alignment: .center) {
                Title("Welcome to DeckUI")
            }
            
            Slide {
                Title("Introduction", subtitle: "What is it?")
                Words("- A Swift DSL used to make slides")
                Words("- This is made for a future talk")
                Words("- Probably never production ready")
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

                Words("""
                struct CounterView: View {
                    @State var count = 0

                    var body: some View {
                        Button {
                            self.count += 1
                        } label: {
                            Text("Press me - \\(self.count)")
                        }
                    }
                }
                """, style: .custom(Font.system(size: 14, design: .monospaced)))
            }

            Slide {
                Title("Made with...")
                Words("""
                Deck(title: "SomeConf 2023") {
                    Slide(alignment: .center) {
                        Title("Welcome to DeckUI")
                    }

                    Slide {
                        Title("Introduction", subtitle: "What is it?")
                        Words("- A Swift DSL used to make slides")
                        Words("- This is made for a future talk")
                        Words("- Probably never production ready")
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
                """, style: .custom(Font.system(size: 14, design: .monospaced)))


            }
        }
    }
}

struct CounterView: View {
    @State var count = 0
    
    var body: some View {
        Button {
            self.count += 1
        } label: {
            Text("Press me - \(self.count)")
        }
    }
}



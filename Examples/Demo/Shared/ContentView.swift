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
        Deck(title: "DeckUI Demo") {
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
                Title("Multiple Columns")
                
                Columns {
                    Column {
                        Words("Left Side", style: .custom(Font.system(size: 40, weight: .bold)))
                        Words("- Left")
                        Words("- Twix")
                        Words("- Is")
                        Words("- Better")
                    }
                    
                    Column {
                        Words("Right Side", style: .custom(Font.system(size: 40, weight: .bold)))
                        Words("- Right")
                        Words("- Twix")
                        Words("- Is")
                        Words("- Better")
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
                }
            }

            Slide {
                Title("Make Deck like...")
                Words("""
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
                """, style: .custom(Font.system(size: 14, design: .monospaced)))


            }
            
            Slide {
                Title("Present like...")
                
                Words("""
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



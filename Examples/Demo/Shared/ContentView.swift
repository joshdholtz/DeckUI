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
                Title("Multiple Columns")
                
                Columns {
                    Column {
                        Words("Left Side", style: .custom(Font.system(size: 40, weight: .bold)))
                        Bullets(style: .bullet) {
                            Words("Left")
                            Words("Twix")
                            Words("Is")
                            Words("Better")
                        }
                    }
                    
                    Column {
                        Words("Right Side", style: .custom(Font.system(size: 40, weight: .bold)))
                        
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
                                }
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

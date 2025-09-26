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
            Slide(alignment: .center, comment: "Here are some presenter notes") {
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
            
            Slide(alignment: .center, comment: "The presenter notes are back!") {
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

            Slide {
                Title("Ruby Code Example")
                Code(.ruby) {
                    """
                    class Person
                      attr_accessor :name, :age

                      def initialize(name, age = 0)
                        @name = name
                        @age = age
                      end

                      def greet
                        puts "Hello, my name is #{@name}"
                        puts "I am #{@age} years old" if @age > 0
                      end

                      private

                      def secret_method
                        # This is a private method
                        :secret_value
                      end
                    end

                    person = Person.new("Alice", 30)
                    person.greet
                    """
                }
            }

            Slide {
                Title("Objective-C Code Example")
                Code(.objc) {
                    """
                    #import <Foundation/Foundation.h>

                    @interface Person : NSObject

                    @property (nonatomic, strong) NSString *name;
                    @property (nonatomic, assign) NSInteger age;

                    - (instancetype)initWithName:(NSString *)name age:(NSInteger)age;
                    - (void)greet;

                    @end

                    @implementation Person

                    - (instancetype)initWithName:(NSString *)name age:(NSInteger)age {
                        self = [super init];
                        if (self) {
                            _name = name;
                            _age = age;
                        }
                        return self;
                    }

                    - (void)greet {
                        NSLog(@"Hello, my name is %@", self.name);
                        if (self.age > 0) {
                            NSLog(@"I am %ld years old", (long)self.age);
                        }
                    }

                    @end
                    """
                }
            }

            Slide {
                Title("Bash Script Example")
                Code(.bash) {
                    """
                    #!/bin/bash

                    # Function to greet a user
                    greet_user() {
                        local name=$1
                        local age=$2

                        echo "Hello, my name is $name"

                        if [ "$age" -gt 0 ]; then
                            echo "I am $age years old"
                        fi
                    }

                    # Main script
                    USERNAME="Alice"
                    AGE=30

                    # Check if user exists
                    if [ -n "$USERNAME" ]; then
                        greet_user "$USERNAME" "$AGE"
                    else
                        echo "No username provided"
                        exit 1
                    fi

                    # List files with colors
                    ls -la --color=auto | grep -E "^d"
                    """
                }
            }

            Slide {
                Title("SQL Query Example")
                Code(.sql) {
                    """
                    -- Create a users table
                    CREATE TABLE users (
                        id INTEGER PRIMARY KEY,
                        name VARCHAR(100) NOT NULL,
                        email VARCHAR(255) UNIQUE,
                        age INTEGER CHECK (age >= 0),
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    );

                    -- Insert some sample data
                    INSERT INTO users (name, email, age) VALUES
                        ('Alice', 'alice@example.com', 30),
                        ('Bob', 'bob@example.com', 25);

                    -- Query with JOIN and aggregation
                    SELECT
                        u.name,
                        COUNT(o.id) AS order_count,
                        AVG(o.total) AS avg_order_value
                    FROM users u
                    LEFT JOIN orders o ON u.id = o.user_id
                    WHERE u.age >= 18
                    GROUP BY u.id, u.name
                    HAVING COUNT(o.id) > 0
                    ORDER BY order_count DESC
                    LIMIT 10;
                    """
                }
            }

            Slide {
                Title("HTML Example")
                Code(.html) {
                    """
                    <!DOCTYPE html>
                    <html lang="en">
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>DeckUI Demo</title>
                        <style>
                            .container { max-width: 800px; margin: 0 auto; }
                            .highlight { color: #ff79b3; font-weight: bold; }
                        </style>
                    </head>
                    <body>
                        <div class="container">
                            <h1 id="main-title">Welcome to DeckUI</h1>
                            <p class="highlight">
                                Build presentations with <strong>Swift</strong>!
                            </p>
                            <button onclick="alert('Hello!')">Click Me</button>

                            <!-- This is a comment -->
                            <form action="/submit" method="post">
                                <input type="text" name="username" placeholder="Enter name" required>
                                <button type="submit">Submit</button>
                            </form>
                        </div>
                    </body>
                    </html>
                    """
                }
            }

            Slide {
                Title("Regex Pattern Example")
                Code(.regex) {
                    """
                    # Email validation pattern
                    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$

                    # Phone number formats
                    \\(?\\d{3}\\)?[-. ]?\\d{3}[-. ]?\\d{4}

                    # URL matching
                    https?://(?:www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b(?:[-a-zA-Z0-9()@:%_\\+.~#?&/=]*)

                    # IPv4 address
                    \\b(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b

                    # Date formats (MM/DD/YYYY or DD-MM-YYYY)
                    (?:0[1-9]|1[0-2])[/](?:0[1-9]|[12][0-9]|3[01])[/]\\d{4}|(?:0[1-9]|[12][0-9]|3[01])[-](?:0[1-9]|1[0-2])[-]\\d{4}

                    # Lookahead/lookbehind assertions
                    (?<=@)[^@]+(?=\\.)  # Domain part of email
                    \\w+(?=ing\\b)       # Words ending in 'ing'
                    (?<!un)important   # 'important' not preceded by 'un'
                    """
                }
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
                        Code(.swift) {
                        """
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
                        """
                        }
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
                        Code(.swift) {
                        """
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
                        """
                        }
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
                        Code(.swift) {
                        """
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
                        """
                        }
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
                        Code(.swift) {
                        """
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
                        """
                        }
                    }
                    
                    Column {
                        Code(.swift, enableHighlight: false) {
                        """
                        // Set theme on presenter
                        var body: some View {
                            Presenter(deck: self.deck, theme: .venonat)
                        }

                        // Or on individual slide
                        Slide(theme: .venonat) {
                            Title("Some slide")
                        }
                        """
                        }
                    }
                }
            }
            
            Slide {
                Title("Bullets", subtitle: "")
                Columns {
                    Column {
                        Code(.swift) {
                        """
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
                        """
                        }
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
                        Code(.swift) {
                        """
                        Slide {
                            Media(.assetImage(""))
                            Media(.bundleImage(""))
                            Media(.remoteImage(URL(string: ""))!)
                        }
                        """
                        }
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
                        Code(.swift) {
                        """
                        Slide {
                            Code(.swift) {
                            \"\"\"
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
                            \"\"\"
                            }
                        }
                        """
                        }
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
                        Code(.swift) {
                        """
                        Slide {
                            Code(.swift) {
                            \"\"\"
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
                            \"\"\"
                            }
                        }
                        """
                        }
                    }
                    
                    Column {
                        Bullets {
                            Words("Easily drop in any code")
                            Words("Up and down highlight lines")
                            Words("Syntax highlight")
                        }
                    }
                }
            }

            Slide {
                Title("RawView", subtitle: "Power is all yours")
                Columns {
                    Column {
                        Code(.swift) {
                        """
                            Slide(alignment: .center) {
                                RawView {
                                    Text("DeckUI")
                                        .font(.system(size: 200, weight: .bold, design: .monospaced))
                                        .foregroundColor(.white)
                                        .padding(60)
                                        .border(.white.opacity(0.5), width: 20)
                                }
                            }
                        """
                        }
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

//
//  ContentView.swift
//  Scroll
//
//  Created by Alexander Scanlan on 27/06/2026.
//

import LedgerKit
import SwiftUI

struct ContentView: View {
    let messages: [Message] = (0..<100).map {
        .init(id: "\($0)", content: "Content: \($0)")
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(messages) { message in
                    Text(message.content)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

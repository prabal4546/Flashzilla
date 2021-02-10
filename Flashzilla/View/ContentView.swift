//
//  ContentView.swift
//  Flashzilla
//
//  Created by PRABALJIT WALIA     on 09/02/21.
//

import SwiftUI

struct ContentView: View {
    @State private var cards = [Card](repeating: Card.example, count: 10)
    var body: some View {
        CardView(card: Card.example)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

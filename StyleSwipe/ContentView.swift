//
//  ContentView.swift
//  StyleSwipe
//  Created by Ayush Krishnappa on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Style Swipe")
                .font(.largeTitle)  // Large font for the main title
                .fontWeight(.bold)  // Makes the text bold
                .padding(.bottom, 10)  // Adds some space between the two texts

            Text("Swipe into Style")
                .font(.title2)  // Slightly smaller font for the subtitle
                .foregroundColor(.gray)  // Sets the color to gray for a nice contrast

            Spacer()  // Pushes the text to the top
        }
        .padding()  // Adds some padding around the whole view
        .navigationBarHidden(true)  // Hides the navigation bar for a clean look
    }
}

#Preview {
    ContentView()
}

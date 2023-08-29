//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Lucek Krzywdzinski on 09/06/2022.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Helcome to SnowSeeker!")
                .font(.title)
            Text("Please select a reasort form the left-hand menu; swipe form left to right to show it.")
                .foregroundColor(.secondary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

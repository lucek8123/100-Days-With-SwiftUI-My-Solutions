//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Lucek Krzywdzinski on 25/05/2022.
//

import SwiftUI

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(hue: geo.frame(in: .global).minY / 1000, saturation: 1.0, brightness: 1.0) )
                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity(Double(geo.frame(in: .global).maxY) / 100)
                            .opacity(Double(fullView.size.height - geo.frame(in: .global).maxY) / 100)
                            .scaleEffect((geo.frame(in: .global).maxY + 50) / fullView.size.width)
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

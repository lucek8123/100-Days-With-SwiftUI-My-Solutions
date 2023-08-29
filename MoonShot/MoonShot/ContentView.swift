//
//  ContentView.swift
//  MoonShot
//
//  Created by Lucek Krzywdzinski on 21/11/2021.
//

import SwiftUI



struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missons: [Mission] = Bundle.main.decode("missions.json")
    
    let colums = [GridItem(.adaptive(minimum: 150))]
    
    @State private var GridShowing = true
    
    var body: some View {
        NavigationView{
            Group {
                if GridShowing {
                    GridLayout(astronauts: astronauts, missons: missons)
                } else {
                    ListLayout(astronauts: astronauts, missions: missons)
                }
                
            }
            .background(.darkBackground)
            .navigationTitle("Moonshot")
            .preferredColorScheme(.dark)
            .toolbar(content: {
                Button {
                    GridShowing.toggle()
                } label: {
                    if GridShowing {
                        Image(systemName: "list.dash")
                    } else {
                        Image(systemName: "square.grid.2x2")
                    }
                }
                .accessibilityLabel("Change View")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

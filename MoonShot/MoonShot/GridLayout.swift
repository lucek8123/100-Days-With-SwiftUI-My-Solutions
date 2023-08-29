//
//  GridLayout.swift
//  MoonShot
//
//  Created by Lucek Krzywdzinski on 13/12/2021.
//

import SwiftUI

struct GridLayout: View {
    let astronauts: [String: Astronaut]
    let missons: [Mission]
    
    let colums = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: colums) {
                ForEach(missons) { mission in
                    NavigationLink {
                        MissionView(mission: mission, astronauts: astronauts)
                    } label: {
                        VStack {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                                .accessibilityHidden(true)
                            VStack{
                                Text(mission.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(mission.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.lightBackground)
                            .accessibilityElement(children: .ignore)
                            .accessibilityAddTraits(.isButton)
                            .accessibilityLabel("\(mission.displayName)")
                            .accessibilityHint("\(mission.formattedLaunchDate == "N/A" ? "Havn't date of launch" : "Launched at \(mission.formattedLaunchDate)")")
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackground)
                        )
                        }
                    
                }
            }
            .padding([.horizontal, .bottom])
        }
        
    }
}

struct GridLayout_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        GridLayout(astronauts: astronauts, missons: missions)
            .preferredColorScheme(.dark)
    }
}

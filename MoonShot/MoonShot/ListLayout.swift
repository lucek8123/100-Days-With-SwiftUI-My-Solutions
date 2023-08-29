//
//  ListLayout.swift
//  MoonShot
//
//  Created by Lucek Krzywdzinski on 13/12/2021.
//

import SwiftUI

struct ListLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    var body: some View {
            List {
                ForEach(missions) { mission in
                    NavigationLink {
                        MissionView(mission: mission, astronauts: astronauts)
                    } label: {
                        HStack {
                            VStack{
                                Text(mission.displayName)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding(.horizontal)
                                Text(mission.formattedLaunchDate)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("\(mission.displayName)")
                            .accessibilityHint("\(mission.formattedLaunchDate == "N/A" ? "Havn't date of launch" : "Launched at \(mission.formattedLaunchDate)")")


                            Spacer()
                            
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .listRowBackground(Color.darkBackground)
            }
            .listStyle(.plain)

        }
    
}

struct ListLayout_Previews: PreviewProvider {
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    
    static var previews: some View {
        ListLayout(astronauts: astronauts, missions: missions)
            .preferredColorScheme(.dark)
    }
}

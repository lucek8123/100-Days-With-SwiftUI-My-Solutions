//
//  ScenePhase-Playground.swift
//  Flashzilla
//
//  Created by Lucek Krzywdzinski on 07/05/2022.
//

import SwiftUI

struct ScenePhase_Playground: View {
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .padding()
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("Active")
                } else if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .background {
                    print("Background")
                }
            }
    }
}

struct ScenePhase_Playground_Previews: PreviewProvider {
    static var previews: some View {
        ScenePhase_Playground()
    }
}

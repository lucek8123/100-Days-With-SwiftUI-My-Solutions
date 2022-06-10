//
//  ContentView.swift
//  Animation
//
//  Created by Lucek Krzywdzinski on 02/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State var isshowingred = true
    var body: some View {
        VStack{
            Button("tap me"){
                withAnimation {
                    isshowingred.toggle()
                }
            }
            .animation(.default.delay(0.01), value: isshowingred)
            if isshowingred {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.scale)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

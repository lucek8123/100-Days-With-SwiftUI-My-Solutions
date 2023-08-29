//
//  SpecificAcessibility.swift
//  Flashzilla
//
//  Created by Lucek Krzywdzinski on 07/05/2022.
//

import SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}

struct SpecificAcessibility: View {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @State private var scale = 1.0
    
    var body: some View {
        Text("Hello World!")
            .scaleEffect(scale)
            .padding()
            .background(reduceTransparency ? .black : .black.opacity(0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct SpecificAcessibility_Previews: PreviewProvider {
    static var previews: some View {
        SpecificAcessibility()
    }
}

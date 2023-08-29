//
//  ContentView.swift
//  Drawing
//
//  Created by Lucek Krzywdzinski on 14/12/2021.
//

import SwiftUI

struct ColorCyclingRectangle: View {
    var steps = 100
    var amount = 0.0
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder( LinearGradient(
                        gradient: Gradient(colors: [color(for: value, brightness: 1),
                                                    color(for: value, brightness: 0.5)]),
                        startPoint: .top,
                        endPoint: .bottom),
                        lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct Arrow: Shape, Animatable {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
    
}

struct ContentView: View {
    @State private var amount = 0.0
    @State private var steps = 100.0
    var body: some View {
        VStack{
            ColorCyclingRectangle(steps: Int(steps), amount: amount)
                .frame(width: 300, height: 300)
            Slider(value: $amount, in: 0...1)
                .shadow(radius: 10)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

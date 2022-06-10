//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Lucek Krzywdzinski on 15/10/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var score = 0
    @State private var question = 0
    @State private var finalAlert = false
    
    @State private var scale: [Double] = [1.0, 1.0, 1.0]
    @State private var rotateCount = [0.0, 0.0, 0.0]
    @State private var opacity: [Double] = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: .blue, location: 0.3),
                .init(color: .red, location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack{
                Text("Guess The Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                VStack(spacing: 20){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy ))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.heavy))
                    }
                    .accessibilityElement()
                    .accessibilityLabel("Tap flag of ")
                    .accessibilityValue(countries[correctAnswer])
                    
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                            withAnimation(.easeOut(duration: 0.5)){
                                rotateCount[number] += 360
                                for count in 0..<3 {
                                    if number != count {
                                        opacity[number] = 0.25
                                        scale[number] = 0.75
                                    }
                                }
                            }
                               
                        } label:{
                            Image(self.countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                .shadow(radius: 20)
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                        .rotation3DEffect(.degrees(rotateCount[number]), axis: (x: 0, y: 1, z:0))
                        .opacity(opacity[number])
                    }
                    
                }
            .padding(.vertical, 20)
            
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            Text("Your score is \(score)/10")
                .foregroundColor(.white)
                .font(.largeTitle.bold())
            Text("Question nr. \(question)")
                    .foregroundColor(.white)
                    .font(.title.bold())

            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Countine", action: NewPart)
        }message: {
            Text("Your score is \(score)/10")
        }
        .alert("Summarize", isPresented: $finalAlert){
            Button("Next Game", action: NewGame)
        }message: {
            Text("You are haveing the \(score)/10 points")
        }
    }
    func flagTapped (_ number :Int) {
        if correctAnswer == number {
            score += 1
            question += 1
            scoreTitle = "Correct"
        }else{
            scoreTitle = "Wrong"
            question += 1
        }
        
        showingScore = true
    }
    func NewPart(){
        if self.question == 10 {
            finalAlert = true
        }else{
            countries = countries.shuffled()
            correctAnswer = Int.random(in: 0...2)
        }
        for count in 0..<3 {
            opacity[count] = 1.0
        }
    }
    func NewGame(){
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
        score = 0
        question = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

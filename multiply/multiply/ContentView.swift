//
//  ContentView.swift
//  multiply
//
//  Created by Lucek Krzywdzinski on 07/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var num1: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var num2: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var NumOfQuestion = 0
    
    @State var questionNum = 1
    @State var questions = [5, 10, 15, 20]
    
    @State private var maxNum = 1
    @State private var maxNumber = [50, 100, 75]
    
    @State private var result = ""

    @State private var showingCorrect = false
    @State private var correctMessage = ""
    @State private var correctTitle = ""
    
    @State private var showingAlert = false
    
    @State private var GameOn = false
    @State private var Points = 0
    
    @FocusState private var isKeyboarFocused: Bool
    
    //main body
    var body: some View {
        ZStack{
            VStack{
                if !GameOn {
                    Forme()
                } else if NumOfQuestion < num1.count {
                    game()
                }
            }
        }
        .onAppear(perform: {
            newGame()
        
        })
        .alert("Summary", isPresented: $showingAlert, actions: {
            Button("OK", action: {
                withAnimation(.default){
                    GameOn = false
                }
            })
        }, message: {
            Text("Your points is \(Points)/\(questions[questionNum])")
        })
        .toolbar(content: {
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button("Done", action: {
                    isKeyboarFocused = false
                })
            })
            
        })

        
    }
    
    // Game View
    func game() -> some View {
        ZStack{
            RadialGradient(stops: [.init(color: .red, location: 0.3), .init(color: .blue, location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                makeSpace(2)
                Text("\(num1[NumOfQuestion]) * \(num2[NumOfQuestion])")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    HStack{
                        Spacer()
                        TextField("Result", text: $result)
                            .focused($isKeyboarFocused)
                            .keyboardType(.numberPad)
                            .foregroundColor(.blue)
                            .padding()
                            .onSubmit {
                                check()
                            }
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
                
                Button(action: {
                    showingCorrect ? nextPart() : check()
                }, label: {
                    Text(showingCorrect ? "Next   " : "Check   ")
                        .foregroundColor(.white)
                        .font(.title.bold())
                        .padding()
                        .background(.mint)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                })
                Text(showingCorrect ? correctTitle : "")
                    .foregroundColor(.white)
                    .font(.title2.bold())
                Text(showingCorrect ? correctMessage : "")
                    .foregroundColor(.white)
                    .font(.title2.bold())
                makeSpace(3)
            }
            
        }
    }
        
    
    
    func makeSpace(_ count: Int) -> some View{
        ForEach(0 ..< count) { _ in
            Spacer()
        }
    }
    
    // Form on start game
    func Forme() -> some View{
        VStack {
            Form {
                Section{
                    Text("Number of questions")
                        .font(.title.bold())
                        .foregroundColor(.cyan)
                    Picker("Number of questions", selection: $questionNum,  content: {
                        ForEach(0...3, id: \.self) { number in
                            Text("\(questions[number])")
                        }
                    })
                        .pickerStyle(.segmented)
                }
                Section {
                    Text("Up to")
                        .font(.title.bold())
                        .foregroundColor(.cyan)
                    Picker("Max number", selection: $maxNum, content: {
                        ForEach(0...2, id: \.self) { number in
                            Text("\(maxNumber[number])")
                        }
                    })
                        .pickerStyle(.segmented)
                }
                
            }
            makeSpace(3)
            Button(action: {
                withAnimation(.spring()){
                    GameOn = true
                }
            }, label: {
                Text("Start      ")
                    .foregroundColor(.white)
                    .font(.title.italic().bold())
                    .padding()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            
            Spacer()
        }
    }
    func newGame() {
        num1 = [ ]
        num2 = [ ]
        NumOfQuestion = 0
        Points = 0
        var questions2 = 0
        while questions2 < questions[questionNum] {
            let num = Int.random(in: 0...10)
            let num3 = Int.random(in: 0...10)
            if num * num3 <= maxNumber[maxNum] {
                num1.append(num)
                num2.append(num3)
                questions2 += 1
            }
            
        }
        num2.shuffle()
        num1.shuffle()
    }
    func check() {
        withAnimation(.default){
        if num1[NumOfQuestion] * num2[NumOfQuestion] == Int(result) ?? 0 {
            correctTitle = "Correct!"
            correctMessage = "Your avanser is correct! Please next :)"
            showingCorrect = true
            Points += 1

        } else {
            correctTitle = "Oh..."
            correctMessage = "Your avanser isn't correct... \nThe correct avanser is \(num1[NumOfQuestion] * num2[NumOfQuestion])"
            showingCorrect = true
        }
        }
    }
    func nextPart() {
        if NumOfQuestion != questions[questionNum] - 1{
        withAnimation(.default, {
            NumOfQuestion += 1
            result = ""
            showingCorrect = false
        })
        } else {
            withAnimation(.default){
                showingAlert = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

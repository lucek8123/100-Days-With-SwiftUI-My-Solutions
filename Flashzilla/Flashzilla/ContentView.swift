//
//  ContentView.swift
//  Flashzilla
//
//  Created by Lucek Krzywdzinski on 06/05/2022.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var cards: [Card] = Cards.shared.objects.isEmpty ? [Card(promt: "You can add cards by clicking edit cards button", answer: "Psst... It is in up right corner")] : Cards.shared.objects
    
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                    .background(.black.opacity(0.7))
                    .clipShape(Capsule())
                
                ZStack {
                    //ForEach(0..<cards.count, id: \.self) { index in
                        //CardView(card: cards[index]) { knowAnswer in
                           // if knowAnswer {
                                //withAnimation {
                              //      removeCard(at: index)
                            //    }
                          //  } else {
                            //    cards.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
                          //  }
                        //}
                        //.stacked(at: index, in: cards.count)
                        //.allowsTightening(index == cards.count - 1)
                      //  .accessibilityHidden(index == cards.count - 1)
                    //}
                    ForEach(cards) { card in
                        let cardIndex = cards.firstIndex {
                            $0.id == card.id
                        }.unsafelyUnwrapped
                        
                        CardView(card: card) { knowAnswer in
                            if knowAnswer {
                                withAnimation {
                                    removeCard(at: cardIndex)
                                }
                            } else {
                                cards.move(fromOffsets: IndexSet(integer: cardIndex), toOffset: 0)
                                
                            }
                        }
                        .stacked(at: cardIndex, in: cards.count)
                        .allowsTightening(cardIndex == cards.count - 1)
                        .accessibilityHidden(cardIndex == cards.count - 1)
                        
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditScreen = true
                    } label: {
                        Label("Edit cards", systemImage: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Capsule())
                    }

                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding() 
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your anwer is being incorrect")
                        Spacer()
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer is being correct ")
                    }
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if !cards.isEmpty {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen) {
            EditCards()
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        cards = Cards.shared.objects.isEmpty ? [Card(promt: "You can add cards by clicking edit cards button", answer: "Psst... It is in up right corner")] : Cards.shared.objects
        timeRemaining = 100
        isActive = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

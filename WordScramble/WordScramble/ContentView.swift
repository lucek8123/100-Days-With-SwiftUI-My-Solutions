//
//  ContentView.swift
//  WordScramble
//
//  Created by Lucek Krzywdzinski on 30/10/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var alertTitile = ""
    @State private var alertMessage = ""
    @State private var isalertShowing = false
    
    @State private var score = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .init(red: 0.1, green: 0.2, blue: 0.45), location: 0.1),
                .init(color: .init(red: 0.76, green: 0.15, blue: 0.26), location: 0.1)], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Text(rootWord.capitalized)
                    .font(.title.bold())
                    .foregroundColor(.white)
                TextField("Enter your word", text: $newWord)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 5) {
                    Text("Rules:")
                        .font(.headline)
                    Text("1 point for word shorter than 5 letters, and 2 points for word longer than 5")
                        .padding(.trailing)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Rules: 1 point for word shorter than 5 letters, and 2 points for word longer than 5")
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(usedWords, id: \.self) { word in
                            HStack{
                                Image(systemName: "\(word.count).circle.fill")
                                Text(word.capitalized)
                                Spacer()
                            }
                            .foregroundColor(.white)
                            .font(.title2)
                            .accessibilityElement()
                            .accessibilityLabel(word)
                            .accessibilityHint("\(word.count) letters")
                        }
                    }
                }
                
                Spacer()
                HStack {
                    Text("Points")
                    Spacer()
                    Text("\(score)")
                }
                .font(.title2)
                .foregroundColor(.white)
                .accessibilityElement()
                .accessibilityLabel("Points")
                .accessibilityValue(String(score))
            }
            .padding()
        }
        .toolbar {
            Button {
                startGame()
            } label: {
                Text("New Game")
                    .foregroundColor(.white)
            }
        }
        .onSubmit(addNewWord)
        .textInputAutocapitalization(.never)
        .onAppear(perform: startGame)
        .alert(alertTitile, isPresented: $isalertShowing){
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        
    }
    func wordError(title: String, message: String) {
        alertMessage = message
        alertTitile = title
        isalertShowing = true
    }
    func addNewWord() {
        // Set newWord lowercase and without any spacees and new lines
        let avanser = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard avanser.count > 0 else { return }

        // Check word
        guard isOriginal(word: avanser) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        guard isReal(avanser) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        guard isLongerThanThree(word: avanser) else {
            wordError(title: "Too short", message: "Please... use longer word!")
            return
        }
        guard isPossible(word: avanser) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        addPoints(word: avanser)
        withAnimation{
            usedWords.insert(avanser, at: 0)
        }
        newWord = ""
    }
    func addPoints(word: String) {
        if word.count < 5 {
            score += 1
            
            return
        }
        score += 2
    }
    func isLongerThanThree(word: String) -> Bool{
        if word.count <= 3 {
            return false
        }
        return true
    }
    func isOriginal(word: String) -> Bool {
        if !usedWords.contains(word) && rootWord != word {
            return true
        } else {
            return false
        }
    }
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    func isReal(_ word: String)-> Bool {
        let checker = UITextChecker()
        let Range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: Range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func startGame(){
        usedWords = [String]()
        score = 0
        if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let Content = try? String(contentsOf: fileURL) {
                let words = Content.components(separatedBy: "\n")
                rootWord = words.randomElement() ?? "slikworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

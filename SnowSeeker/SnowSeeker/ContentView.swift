//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Lucek Krzywdzinski on 06/06/2022.
//

import SwiftUI

extension View {
    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView: View {
    @State private var searchText = ""
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @StateObject var favorites = Favorites()
    
    @State private var showingDialog = false
    @State private var sorting = SortingType.normal
    
    enum SortingType {
        case country, alphabetical, normal
    }
    
    var body: some View {
        NavigationView {
            List(sortedResorts) { resort in
                NavigationLink {
                        ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "star.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for resort")
            .navigationTitle("Resorts")
            .confirmationDialog("Select sort of list", isPresented: $showingDialog) {
                Button("Default") { sorting = .normal }
                Button("Alphabetical") { sorting = .alphabetical }
                Button("Country") { sorting = .country }
            }
            .toolbar {
                Button {
                    showingDialog = true
                } label: {
                    Label("Sorting options", systemImage: "list.bullet.circle")
                }
            }
            
            
            WelcomeView()
        }
        .phoneOnlyNavigationView()
        .environmentObject(favorites)
    }
    
    var filtredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.contains(searchText) }
        }
    }
    
    var sortedResorts: [Resort] {
        switch sorting {
        case .country:
            return filtredResorts.sorted {
                $0.country < $1.country
            }
        case .alphabetical:
            return filtredResorts.sorted {
                $0.name < $1.name
            }
        case .normal:
            return filtredResorts
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

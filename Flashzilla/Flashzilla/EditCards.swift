//
//  EditCards.swift
//  Flashzilla
//
//  Created by Lucek Krzywdzinski on 16/05/2022.
//

import SwiftUI

struct EditCards: View {
    @StateObject var cards = Cards.shared
    @State private var editMode = EditMode.inactive
    
    @State private var addViewShowing = false
    @State private var editItem: Card?
        
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            Form {
                ForEach(cards.objects) { card in
                    Button {
                        editItem = card
                    } label: {
                        VStack(alignment: .leading) {
                            Text(card.promt)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(card.answer)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .navigationTitle("Edit cards")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        addViewShowing = true
                    } label: {
                        Label("Add new card", systemImage: "plus")
                    }
                    .disabled(editMode == .active)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .disabled(editMode == .active)
                }
            }
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $addViewShowing) {
                AddView(isAdding: true) { saveItem in
                    cards.objects.append(saveItem)
                }
            }
            .sheet(item: $editItem) { item in
                AddView(card: item, isAdding: false) { saveItem in
                    let index = cards.objects.firstIndex {
                        $0.id == saveItem.id
                    }
                    guard let index = index else {
                        return
                    }
                    
                    cards.objects[index] = saveItem
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        cards.objects.remove(atOffsets: offsets)
    }
    
    func move(source: IndexSet, destination: Int) {
        cards.objects.move(fromOffsets: source, toOffset: destination)
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards()
    }
}

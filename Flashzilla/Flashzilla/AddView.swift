//
//  AddView.swift
//  Flashzilla
//
//  Created by Lucek Krzywdzinski on 18/05/2022.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State var card: Card = Card(promt: "", answer: "")
    let isAdding: Bool
    
    let onSave: (Card) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Question") {
                    TextField("Please, add question", text: $card.promt)
                }
                Section("Answer") {
                    TextField("Please, add answer", text: $card.answer)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if isAdding {
                        Button {
                            onSave(card)
                            dismiss()
                        } label: {
                            Label("Add card", systemImage: "plus")
                        }
                        .disabled(card.answer.isEmpty || card.promt.isEmpty)
                    } else {
                        Button {
                            onSave(card)
                            dismiss()
                        } label: {
                            Text("Save")
                        }
                        .disabled(card.answer.isEmpty || card.promt.isEmpty)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .navigationTitle("\(isAdding ? "Add" : "Edit") card")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(card: .empty, isAdding: false) { _ in print("Saved!") }
    }
}

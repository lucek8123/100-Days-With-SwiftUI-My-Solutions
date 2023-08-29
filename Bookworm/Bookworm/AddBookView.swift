//
//  AddBookView.swift
//  Bookworm
//
//  Created by Lucek Krzywdzinski on 15/01/2022.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    @State private var alertTitle = ""
    @State private var alertShowing = false
    @State private var alertMessage = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    TextField("Name of the book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genere", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                }
                
                Section {
                    Button("Save") {
                        // add the book
                        if checkFields {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.rateing = Int16(rating)
                            newBook.genre = genre
                            newBook.review = review
                            newBook.date = Date.now
                            
                            try? moc.save()
                            dismiss()
                        } else {
                            alertTitle = "Error"
                            alertMessage = "Some fields are empty. Please repair that. "
                            alertShowing = true
                        }
                    }
                }
            }
            .navigationTitle("Add book")
            .alert(alertTitle, isPresented: $alertShowing) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var checkFields: Bool {
        if title.isEmpty && genre.isEmpty && author.isEmpty {
            return false
        }
        return true
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}

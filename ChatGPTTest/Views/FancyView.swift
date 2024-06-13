//
//  FancyView.swift
//  ChatGPTTest
//
//  Created by Russell Gordon on 2024-06-13.
//

import SwiftUI

// MODEL
struct Book: Identifiable, Codable {
    let id: Int
    let name: String
    let author: String
}

let exampleBooks = [
    Book(id: 1, name: "Outlander", author: "Diana Gabaldon"),
    Book(id: 2, name: "The Mountain in the Sea", author: "Ray Nayler"),
]

// VIEW
struct FancyView: View {
    
    // MARK: Stored properties
    
    // Keeps track of the books the user already likes
    @State private var booksAlreadyRead: [Book] = exampleBooks
    
    // Keeps track of the book a user is entering
    @State private var newBookName = ""
    @State private var newBookAuthor = ""
        
    // MARK: Computed properties
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {

                // Controls to add a book the user has liked
                Group {
                    Text("Please add a few books that you've liked")
                        .font(.title3)
                    TextField("Name of book", text: $newBookName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Author of book", text: $newBookAuthor)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        // Add the book to the list of books the user likes
                        let newBook = Book(
                            id: booksAlreadyRead.count + 1,
                            name: newBookName,
                            author: newBookAuthor
                        )
                        // Add to top of list
                        booksAlreadyRead.insert(newBook, at: 0)
                    } label: {
                        Text("Add")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                // Show the books the user has entered
                List(booksAlreadyRead) { book in
                    VStack(alignment: .leading) {
                        Text(book.name)
                            .bold()
                        Text(book.name)
                            .font(.subheadline)
                    }
                }
                .listStyle(.plain)
                
                Spacer()

            }
            .padding()
            .navigationTitle("Fancy Test")
        }
    }
}

#Preview {
    LandingView(selectedTab: Binding.constant(2))
}

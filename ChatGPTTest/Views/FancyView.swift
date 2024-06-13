//
//  FancyView.swift
//  ChatGPTTest
//
//  Created by Russell Gordon on 2024-06-13.
//

import OpenAI
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
    
    // The response from ChatGPT
    @State private var response: String? = nil
        
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
                .frame(height: 200)
                                
                // Allow user to ask for book recommendations
                Button {
                    Task {
                        response = try await getBookRecommendation()
                    }
                } label: {
                    Text("Get Book Recommendations")
                }
                .buttonStyle(.borderedProminent)

                // Only show the text view when there is a response...
                if let response = response {
                    Text(response)
                        .monospaced()
                }
                
                Spacer()

            }
            .padding()
            .navigationTitle("Fancy Test")
        }
    }
    
    // MARK: Functions
    private func getBookRecommendation() async throws -> String? {
        
        // Encode the list of books to JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        var booksListInJSON = ""
        do {
            let jsonData = try encoder.encode(booksAlreadyRead)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                booksListInJSON = jsonString
            }
        } catch {
            debugPrint(error)
            return nil
        }
        
        // NOTE: See Mr. Gordon to obtain your API key.
        //
        //       Add a file named Secrets.swift to a Helpers group in your project.
        //       The file must be named exactly as shown.
        //       Define a constant named like this that includes the apiKey you were provided with:
        //
        //       let apiKey = "REPLACE_WITH_YOUR_API_KEY"
        //
        let openAI = OpenAI(apiToken: apiKey)
                
        // Define the question preamble
        let questionPreamble = """
                    I've read these books recently and really enjoyed them.

                    I am providing the information to you in JSON format, with two name-value pairs describing the name and author of each book.

                    Using the same JSON structure, please give me a recommendation for three new books to read.
                    
                    
                    """
        
        // Define the question conclusion
        let questionConclusion = """
                    
                    
                    Please include only the JSON structure in your response, with no other text before or after your reply.
                    """
        
        // Assemble the entire question
        let question = questionPreamble + booksListInJSON + questionConclusion
        // DEBUG
        print("======")
        print(question)
        
        // Build the query
        let query = ChatQuery(
            messages: [ChatQuery.ChatCompletionMessageParam(
                role: .user,
                content: question
            )!],
            model: .gpt4_o
        )

        do {
            // Execute the query
            let result = try await openAI.chats(query: query)
            
            // Once query is received, return the response
            return result.choices.first?.message.content?.string ?? nil
        } catch {
            debugPrint(error)
        }
        
        // Shouldn't ever get here, but a return statement to satisfy the Swift compiler
        return nil

    }

}

#Preview {
    LandingView(selectedTab: Binding.constant(2))
}

import SwiftUI

struct BookListView: View {
    @State private var searchText = ""
    
    let books = [
        Book(id: 1, imageName: "cover1", title: "A TEMPEST OF TEA", synopsis: "In a world where tea holds magical properties, a young woman discovers her hidden abilities as she embarks on a quest to save her realm from an impending darkness.", category: "Popular"),
        Book(id: 2, imageName: "Image 1", title: "SOUL LANTERN", synopsis: "A grieving artist stumbles upon an ancient lantern that allows him to communicate with lost souls. As he helps them find peace, he begins to heal his own heart.", category: "Popular"),
        Book(id: 3, imageName: "Image", title: "A DUET FOR ME", synopsis: "Two rival musicians are forced to collaborate on a symphony that will change their lives. Amidst conflict and collaboration, they discover a deeper connection.", category: "Popular"),
        Book(id: 4, imageName: "book1", title: "THINGS WE NEVER GOT OVER", synopsis: "In the aftermath of a devastating loss, a family struggles to rebuild their lives while uncovering long-buried secrets that challenge their understanding of the past.", category: "New"),
        Book(id: 5, imageName: "Image 2", title: "NOT HERE TO BE LIKE", synopsis: "A young woman leaves her small town for the big city, only to find herself entangled in a web of deceit and self-discovery as she seeks to carve her own path.", category: "New"),
        Book(id: 6, imageName: "book2", title: "HERE TO US", synopsis: "A group of friends reunites for a summer vacation, only to confront the unresolved issues and hidden feelings that have lingered over the years.", category: "New"),
        Book(id: 7, imageName: "book4", title: "WASTED WORDS", synopsis: "An aspiring poet battles with writer's block and personal demons while trying to finish his magnum opus. As he delves into his past, he uncovers truths that might inspire his greatest work.", category: "Favorites"),
        Book(id: 8, imageName: "book5", title: "THE LUCKY LIST", synopsis: "A teenager creates a list of things she wants to do before she graduates high school. As she completes each item, she discovers unexpected truths about herself and her future.", category: "Favorites"),
        Book(id: 9, imageName: "Image", title: "A DUET FOR HOME", synopsis: "A renowned chef and a reclusive writer come together to create a cookbook that bridges their worlds. Through their collaboration, they uncover the transformative power of food and storytelling.", category: "Favorites")
    ]
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var categories: [String] {
        // Find unique categories in filtered books
        Set(filteredBooks.map { $0.category }).sorted()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Gradient view at the top
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.2), Color.pink.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)
                .edgesIgnoringSafeArea(.top)
                .overlay(
                    VStack {
                        TextField("Search for a book", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                )
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                                .font(.headline)
                            
                            HStack(spacing: 10) {
                                ForEach(filteredBooks.filter { $0.category == category }) { book in
                                    NavigationLink(destination: BookDetailView(bookImage: book.imageName, bookTitle: book.title, bookSynopsis: book.synopsis)) {
                                        BookButton(imageName: book.imageName, title: book.title)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationTitle("")
                .navigationBarItems(leading: Text("Librong James")
                    .padding(20)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .semibold)) // Custom font size
                )
            }
        }
    }
}

struct BookButton: View {
    let imageName: String
    let title: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: 110, height: 170)
                .cornerRadius(8)
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

struct BookDetailView: View {
    let bookImage: String
    let bookTitle: String
    let bookSynopsis: String
    
    @State private var isFavorited = false
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var comments: [String] = []
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.8), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    Image(bookImage)
                        .resizable()
                        .frame(width: 200, height: 300)
                        .padding(.top, 20)
                        .cornerRadius(8)
                    
                    Text(bookTitle)
                        .font(.title)
                        .padding(.top, 10)
                    
                    Text(bookSynopsis)
                        .font(.body)
                        .padding()
                    
                    HStack {
                        Text("Rate the book:")
                        
                        HStack {
                            ForEach(1..<6) { i in
                                Image(systemName: i <= rating ? "star.fill" : "star")
                                    .foregroundColor(i <= rating ? .yellow : .gray)
                                    .onTapGesture {
                                        rating = i
                                    }
                            }
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        isFavorited.toggle()
                    }) {
                        Label(isFavorited ? "Unfavorite" : "Favorite", systemImage: isFavorited ? "heart.fill" : "heart")
                            .foregroundColor(isFavorited ? .red : .blue)
                    }
                    .padding()
                    .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text("Comments")
                            .font(.headline)
                            .padding(.top, 20)
                        
                        ForEach(comments, id: \.self) { comment in
                            Text(comment)
                                .padding(.bottom, 10)
                        }
                        
                        HStack {
                            TextField("Add a comment...", text: $comment)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
                                if !comment.isEmpty {
                                    comments.append(comment)
                                    comment = ""
                                }
                            }) {
                                Text("Add")
                                    .frame(width: 40, height: 5) // Adjust width and height as needed
                                    .padding()
                                    .background(Color.pink)
                                    .foregroundColor(.white)
                                    .cornerRadius(6) // Adjust corner radius for better visuals
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle(bookTitle)
    }
}

struct Book: Identifiable {
    let id: Int
    let imageName: String
    let title: String
    let synopsis: String
    let category: String
}

struct ContentView: View {
    var body: some View {
        BookListView()
    }
}

#Preview {
    ContentView()
}

#Preview {
    BookListView()
}

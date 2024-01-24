import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query() private var items: [Item]
    @State var title = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text(item.text ?? "No Description")
                    } label: {
                        Text(item.title)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .opacity(isLoading ? 0 : 100)
            .overlay {
                if isLoading {
                    ProgressView("Loading...")
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: reloadItems) {
                        Label("Add Item", systemImage: "arrow.up.arrow.down")
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
        } detail: {
            Text("Select an item")
        }
        .onAppear(perform: {
            setTitle()
        })


    }


    private func reloadItems() {
        isLoading = true
        
        Task {
            try await fetchNews {
                isLoading = false
                title = "Downloaded"
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func deleteAll() {
        do {
            try modelContext.delete(model: Item.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func setTitle() {
        title = items.isEmpty ? "Downloaded" : "From SwiftData"
    }
    
    private func fetchNews(completion: ()->()) async throws {
        deleteAll()
        
        let url = URL(string: "https://newsapi.org/v2/everything?q=Apple&apiKey=8815d577462a4195a64f6f50af3ada08&page=0")
        let request = URLRequest(url: url!)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let news = try JSONDecoder().decode(Articles.self, from: data)
        
        news.articles.forEach { modelContext.insert(Item(id: $0.id, title: $0.title, text: $0.description)) }

        completion()
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

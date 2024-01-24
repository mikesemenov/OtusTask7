import Foundation

struct Articles: Codable {
    let articles: [News]
    
    init(
        articles: [News]
    ) {
        self.articles = articles
    }
}


struct News: Codable, Identifiable {
    let id: UUID = UUID()
    let author: String?
    let title, description: String
    let url: String?
    
    init(
        author: String?,
        title: String,
        description: String,
        url: String?
    ) {
        self.author = author
        self.title = title
        self.description = description
        self.url = url
    }
    
    private enum CodingKeys: String, CodingKey {
        case author, title, description, url
    }
}

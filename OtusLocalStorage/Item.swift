import Foundation
import SwiftData

@Model
final class Item {
    let id: UUID
    let title: String
    let text: String?
    
    init(id: UUID, title: String, text: String? = nil) {
        self.id = id
        self.title = title
        self.text = text
    }
}

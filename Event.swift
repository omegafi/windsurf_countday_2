import Foundation

public struct Event: Identifiable {
    public let id = UUID()
    public let title: String
    public let date: Date
    public let imageURL: URL?
    public let description: String
    
    public init(title: String, date: Date, imageURL: URL? = nil, description: String) {
        self.title = title
        self.date = date
        self.imageURL = imageURL
        self.description = description
    }
    
    public static var sample: Event {
        Event(
            title: "Windsurf Etkinliği",
            date: Date().addingTimeInterval(86400),
            imageURL: nil,
            description: "Alaçatı'da Windsurf Etkinliği"
        )
    }
}

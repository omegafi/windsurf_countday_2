import Foundation
import SwiftUI

actor EventManager {
    static let shared = EventManager()
    
    private init() {}
    
    private let userDefaults = UserDefaults(suiteName: "group.com.windsurf.countday")!
    
    var events: [Event] {
        get async {
            if let data = userDefaults.data(forKey: "savedEvents"),
               let decodedEvents = try? JSONDecoder().decode([Event].self, from: data) {
                return decodedEvents
            }
            return [Event.sample]
        }
    }
    
    private func saveEvents(_ events: [Event]) {
        if let encodedData = try? JSONEncoder().encode(events) {
            userDefaults.set(encodedData, forKey: "savedEvents")
        }
    }
    
    func getEvent(withId id: UUID) async -> Event? {
        let currentEvents = await events
        return currentEvents.first { $0.id == id }
    }
    
    func addEvent(_ event: Event) async {
        var currentEvents = await events
        currentEvents.append(event)
        saveEvents(currentEvents)
    }
    
    func removeEvent(withId id: UUID) async {
        var currentEvents = await events
        currentEvents.removeAll { $0.id == id }
        saveEvents(currentEvents)
    }
}

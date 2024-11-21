import Foundation
import SwiftUI
import SwiftData

@Model
final class SpecialDay {
    var title: String
    var date: Date
    var type: SpecialDayType
    var themeColor: String
    var notes: String?
    var reminderEnabled: Bool
    var reminderDate: Date?
    
    init(
        title: String,
        date: Date,
        type: SpecialDayType,
        themeColor: String? = nil,
        notes: String? = nil,
        reminderEnabled: Bool = false,
        reminderDate: Date? = nil
    ) {
        self.title = title
        self.date = date
        self.type = type
        self.themeColor = themeColor ?? type.defaultColor
        self.notes = notes
        self.reminderEnabled = reminderEnabled
        self.reminderDate = reminderDate
    }
    
    var isCountingForward: Bool {
        date < Date()
    }
    
    var remainingDays: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
    
    var remainingDaysText: String {
        let days = abs(remainingDays)
        if isCountingForward {
            return "\(days) gün geçti"
        } else {
            return "\(days) gün kaldı"
        }
    }
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
}

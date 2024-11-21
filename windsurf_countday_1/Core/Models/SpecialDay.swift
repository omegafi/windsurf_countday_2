import SwiftUI
import SwiftData

@Model
final class SpecialDay: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var date: Date
    var type: SpecialDayType
    var themeColor: String
    var isCountingForward: Bool
    var notes: String?
    
    // Hatırlatıcı özellikleri
    var reminderEnabled: Bool
    var reminderDate: Date?
    
    // Metadata
    var createdAt: Date
    var lastModifiedAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        type: SpecialDayType,
        themeColor: String? = nil,
        isCountingForward: Bool = false,
        notes: String? = nil,
        reminderEnabled: Bool = false,
        reminderDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.themeColor = themeColor ?? type.defaultColor
        self.isCountingForward = isCountingForward
        self.notes = notes
        self.reminderEnabled = reminderEnabled
        self.reminderDate = reminderDate
        self.createdAt = Date()
        self.lastModifiedAt = Date()
    }
    
    // Günler arası hesaplama metodları
    var daysCount: Int {
        Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
    
    // Son düzenlenme tarihini güncelleme
    func update() {
        lastModifiedAt = Date()
    }
    
    // Etkinlik güncelleme fonksiyonu
    func updateSpecialDay(
        title: String? = nil,
        date: Date? = nil,
        type: SpecialDayType? = nil,
        themeColor: String? = nil,
        isCountingForward: Bool? = nil,
        notes: String? = nil,
        reminderEnabled: Bool? = nil,
        reminderDate: Date? = nil
    ) {
        if let title = title { self.title = title }
        if let date = date { self.date = date }
        if let type = type { 
            self.type = type
            if themeColor == nil {
                self.themeColor = type.defaultColor
            }
        }
        if let themeColor = themeColor { self.themeColor = themeColor }
        if let isCountingForward = isCountingForward { self.isCountingForward = isCountingForward }
        if let notes = notes { self.notes = notes }
        if let reminderEnabled = reminderEnabled { 
            self.reminderEnabled = reminderEnabled
            if !reminderEnabled {
                self.reminderDate = nil
            }
        }
        if let reminderDate = reminderDate { self.reminderDate = reminderDate }
        
        // Son güncelleme tarihini güncelle
        self.lastModifiedAt = Date()
    }
}

enum SpecialDayType: String, CaseIterable, Codable, Identifiable {
    case birthday = "Birthday"
    case anniversary = "Anniversary"
    case healthCheckup = "Health Checkup"
    case graduation = "Graduation"
    case religious = "Religious"
    case newYear = "New Year"
    case mothersDay = "Mother's Day"
    case fathersDay = "Father's Day"
    case quitSmoking = "Quit Smoking"
    case dietTracking = "Diet Tracking"
    case sportsRoutine = "Sports Routine"
    case medication = "Medication"
    case custom = "Custom"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
    
    var icon: String {
        switch self {
        case .birthday: return "birthday.cake"
        case .anniversary: return "heart.circle"
        case .healthCheckup: return "heart.text.square"
        case .graduation: return "graduationcap"
        case .religious: return "moon.stars"
        case .newYear: return "sparkles"
        case .mothersDay: return "heart"
        case .fathersDay: return "figure.wave"
        case .quitSmoking: return "smoke"
        case .dietTracking: return "scalemass"
        case .sportsRoutine: return "figure.run"
        case .medication: return "pills"
        case .custom: return "star"
        }
    }
    
    var defaultColor: String {
        switch self {
        case .birthday: return "#FF69B4" // Pink
        case .anniversary: return "#FF0000" // Red
        case .healthCheckup: return "#4169E1" // Royal Blue
        case .graduation: return "#800080" // Purple
        case .religious: return "#228B22" // Forest Green
        case .newYear: return "#FFA500" // Orange
        case .mothersDay: return "#FF69B4" // Pink
        case .fathersDay: return "#4169E1" // Royal Blue
        case .quitSmoking: return "#808080" // Gray
        case .dietTracking: return "#32CD32" // Lime Green
        case .sportsRoutine: return "#FF8C00" // Dark Orange
        case .medication: return "#4169E1" // Royal Blue
        case .custom: return "#FFD700" // Gold
        }
    }
}

struct SpecialDayTypePickerView: View {
    @Binding var selectedType: SpecialDayType
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(SpecialDayType.allCases) { type in
                        TypeCard(
                            type: type, 
                            isSelected: selectedType == type,
                            width: geometry.size.width * 0.6
                        )
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedType = type
                            }
                        }
                    }
                }
                .padding()
            }
            .scrollTargetBehavior(.paging)
        }
        .frame(height: 250)
    }
}

struct TypeCard: View {
    let type: SpecialDayType
    let isSelected: Bool
    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                // Arka plan
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: type.defaultColor).opacity(0.1))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                // İçerik
                VStack(spacing: 15) {
                    Image(systemName: type.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(hex: type.defaultColor))
                    
                    Text(type.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .padding()
            }
            .frame(width: width, height: 200)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(), value: isSelected)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hex: type.defaultColor), lineWidth: isSelected ? 3 : 0)
            )
        }
    }
}

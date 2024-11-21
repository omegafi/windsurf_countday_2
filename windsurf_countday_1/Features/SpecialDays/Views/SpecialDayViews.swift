import SwiftUI
import SwiftData

struct SpecialDaySliderView: View {
    let day: SpecialDay
    @Environment(\.colorScheme) private var colorScheme
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var subtitleColor: Color {
        colorScheme == .dark ? .white.opacity(0.9) : .black.opacity(0.7)
    }
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            ZStack {
                // Arka plan
                Rectangle()
                    .fill(Color(hex: day.themeColor).opacity(0.15))
                    .ignoresSafeArea()
                
                // İçerik
                VStack {
                    Spacer()
                    
                    // Üst kısım: Icon ve Başlık
                    VStack(spacing: 16) {
                        Image(systemName: day.type.icon)
                            .font(.system(size: 44))
                            .foregroundColor(textColor)
                        
                        Text(day.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(textColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Gün Sayısı ve Tarih
                    VStack(spacing: 10) {
                        Text("\(daysDifference(from: day.date))")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(textColor)
                            .shadow(color: .white.opacity(0.5), radius: 2)
                            .padding(.bottom, 4)
                        
                        Text(day.isCountingForward ? "days since" : "days left")
                            .font(.title3)
                            .foregroundColor(subtitleColor)
                            .padding(.bottom, 8)
                        
                        Text(day.date, style: .date)
                            .font(.headline)
                            .foregroundColor(subtitleColor)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .opacity(0.7)
                    )
                    
                    Spacer()
                    
                    // Alt bilgi
                    HStack {
                        Spacer()
                        Text("Detaylar için tıklayın")
                            .font(.caption)
                            .foregroundColor(subtitleColor)
                            .padding(.bottom, 20)
                            .padding(.trailing)
                    }
                }
                .padding()
            }
            .background(
                Color(hex: day.themeColor)
                    .ignoresSafeArea()
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SpecialDayRowView: View {
    let day: SpecialDay
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color(hex: day.themeColor).opacity(0.2))
                    
                    Image(systemName: day.type.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(hex: day.themeColor))
                }
                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.title)
                        .font(.headline)
                    
                    Text(day.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(daysDifference(from: day.date))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: day.themeColor))
                    
                    Text(day.isCountingForward ? "days since" : "days left")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(hex: day.themeColor).opacity(0.05))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SpecialDayGridItemView: View {
    let day: SpecialDay
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            VStack(spacing: 12) {
                // Icon ve Tip
                ZStack {
                    Circle()
                        .fill(Color(hex: day.themeColor).opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: day.type.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(hex: day.themeColor))
                }
                
                // Başlık
                Text(day.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Spacer(minLength: 8)
                
                // Gün Sayısı
                Text("\(daysDifference(from: day.date))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: day.themeColor))
                
                // Gün Durumu
                Text(day.isCountingForward ? "gün geçti" : "gün kaldı")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Tarih
                Text(day.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: day.themeColor).opacity(0.05))
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
}

struct SpecialDayCardView: View {
    let day: SpecialDay
    @Environment(\.colorScheme) private var colorScheme
    
    private func lighterColor(_ hex: String) -> Color {
        let baseColor = Color(hex: hex)
        return baseColor.opacity(0.8)
    }
    
    private var textColor: Color {
        colorScheme == .dark ? .white : Color(hex: day.themeColor).opacity(0.9)
    }
    
    private var subtitleColor: Color {
        colorScheme == .dark ? .white.opacity(0.9) : Color(hex: day.themeColor).opacity(0.7)
    }
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            ZStack {
                // Arka plan
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: day.themeColor).opacity(0.05),
                        Color(hex: day.themeColor).opacity(0.3),
                        Color(hex: day.themeColor).opacity(0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // İçerik
                VStack {
                    Spacer()
                    
                    // Üst kısım: Icon ve Başlık
                    VStack(spacing: 16) {
                        Image(systemName: day.type.icon)
                            .font(.system(size: 44))
                            .foregroundStyle(textColor)
                        
                        Text(day.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(textColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Orta kısım: Gün Sayısı
                    VStack(spacing: 12) {
                        Text("\(daysDifference(from: day.date))")
                            .font(.system(size: 96, weight: .bold))
                            .foregroundStyle(textColor)
                            .shadow(color: Color(hex: day.themeColor).opacity(0.3), radius: 2)
                            .padding(.bottom, 4)
                        
                        Text(day.isCountingForward ? "gün geçti" : "gün kaldı")
                            .font(.title3)
                            .foregroundStyle(subtitleColor)
                            .padding(.bottom, 8)
                        
                        Text(day.date, style: .date)
                            .font(.callout)
                            .foregroundStyle(subtitleColor)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .opacity(0.7)
                    )
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// MARK: - Helper Functions
private func daysDifference(from date: Date) -> Int {
    Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let hex = String(format: "#%02lX%02lX%02lX", lround(Double(r * 255)), lround(Double(g * 255)), lround(Double(b * 255)))
        return hex
    }
}

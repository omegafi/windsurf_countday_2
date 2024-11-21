import SwiftUI
import SwiftData

struct SpecialDaySliderView: View {
    let day: SpecialDay
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            ZStack {
                // Arka plan
                Rectangle()
                    .fill(Color(hex: day.themeColor).opacity(0.15))
                    .ignoresSafeArea()
                
                // İçerik
                VStack(spacing: 20) {
                    // Icon ve Başlık
                    VStack(spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: day.themeColor).opacity(0.3))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: day.type.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                        
                        Text(day.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Gün Sayısı ve Tarih
                    VStack(spacing: 10) {
                        Text("\(daysDifference(from: day.date))")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(day.isCountingForward ? "days since" : "days left")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(day.date, style: .date)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.bottom, 60)
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
                // İkon Alanı
                ZStack {
                    Circle()
                        .fill(Color(hex: day.themeColor).opacity(0.2))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: day.type.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color(hex: day.themeColor))
                }
                
                // Başlık
                Text(day.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                
                Spacer(minLength: 8)
                
                // Gün Sayısı
                Text("\(daysDifference(from: day.date))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: day.themeColor))
                
                // Alt Bilgi
                Text(day.isCountingForward ? "gün geçti" : "gün kaldı")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(day.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: day.themeColor).opacity(0.05))
                    .shadow(color: Color(hex: day.themeColor).opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SpecialDayCardView: View {
    let day: SpecialDay
    
    var body: some View {
        NavigationLink(destination: SpecialDayDetailView(day: day)) {
            GeometryReader { geometry in
                ZStack {
                    // Gradient Arka Plan
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: day.themeColor).opacity(0.7),
                            Color(hex: day.themeColor).opacity(0.5),
                            Color(hex: day.themeColor).opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // Dekoratif Daireler
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: geometry.size.width * 0.3, y: -geometry.size.height * 0.2)
                        .blur(radius: 30)
                    
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: geometry.size.width * 0.6)
                        .offset(x: -geometry.size.width * 0.2, y: geometry.size.height * 0.3)
                        .blur(radius: 20)
                    
                    // Ana İçerik
                    VStack {
                        Spacer()
                        
                        // İkon ve Başlık
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: day.type.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                            }
                            
                            Text(day.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .shadow(radius: 2)
                        }
                        
                        Spacer()
                        
                        // Gün Sayısı ve Detaylar
                        VStack(spacing: 15) {
                            Text("\(daysDifference(from: day.date))")
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                            
                            Text(day.isCountingForward ? "gün geçti" : "gün kaldı")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text(day.date, style: .date)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .buttonStyle(PlainButtonStyle())
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

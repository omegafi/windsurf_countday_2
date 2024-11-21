import SwiftUI
import SwiftData

@Model
final class AppSettings {
    var language: String
    var useBiometricAuth: Bool
    var usePasscodeAuth: Bool
    var passcode: String?
    var notificationsEnabled: Bool
    var theme: AppTheme
    var isPremium: Bool
    
    init(language: String = Locale.current.language.languageCode?.identifier ?? "en",
         useBiometricAuth: Bool = false,
         usePasscodeAuth: Bool = false,
         passcode: String? = nil,
         notificationsEnabled: Bool = true,
         theme: AppTheme = .system,
         isPremium: Bool = false) {
        self.language = language
        self.useBiometricAuth = useBiometricAuth
        self.usePasscodeAuth = usePasscodeAuth
        self.passcode = passcode
        self.notificationsEnabled = notificationsEnabled
        self.theme = theme
        self.isPremium = isPremium
    }
}

enum AppTheme: String, CaseIterable, Codable {
    case light
    case dark
    case system
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

// deneme

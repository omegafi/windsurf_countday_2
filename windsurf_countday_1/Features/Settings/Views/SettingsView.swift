import SwiftUI

// Tema modu için enum
enum ThemeMode: String, CaseIterable {
    case system, light, dark
    
    var title: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    var icon: String {
        switch self {
        case .system: return "iphone"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .system: return .blue
        case .light: return .orange
        case .dark: return .indigo
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @AppStorage("themeMode") private var themeMode: ThemeMode = .system
    @State private var showOnboarding = false
    @State private var showResetConfirmation = false
    
    private let backgroundColor = Color(.systemGroupedBackground)
    private let secondaryColor = Color(.secondarySystemGroupedBackground)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    appSection
                    appearanceSection
                    generalSection
                    aboutSection
                    supportSection
                    versionSection
                }
                .padding(.vertical)
            }
            .background(backgroundColor)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
        .alert("Reset App", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                isFirstLaunch = true
                themeMode = .system
                dismiss()
            }
        } message: {
            Text("This will reset all settings to their defaults. This action cannot be undone.")
        }
        .preferredColorScheme(themeMode == .system ? nil : (themeMode == .dark ? .dark : .light))
    }
    
    private var appSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "calendar.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(.blue)
            
            Text("CountDay")
                .font(.title2.bold())
            
            Text("Track Your Special Moments")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(secondaryColor)
    }
    
    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Appearance")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 1) {
                Menu {
                    ForEach(ThemeMode.allCases, id: \.self) { mode in
                        Button {
                            withAnimation {
                                themeMode = mode
                            }
                        } label: {
                            Label {
                                Text(mode.title)
                            } icon: {
                                Image(systemName: mode.icon)
                                    .foregroundColor(mode.iconColor)
                            }
                        }
                    }
                } label: {
                    HStack {
                        SettingRow(icon: "paintbrush.fill", 
                                 title: "Theme",
                                 iconColor: .purple,
                                 showChevron: false)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: themeMode.icon)
                                .foregroundColor(themeMode.iconColor)
                            Text(themeMode.title)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                    }
                    .contentShape(Rectangle())
                }
            }
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
    }
    
    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("General")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 1) {
                Button {
                    showOnboarding = true
                } label: {
                    SettingRow(icon: "book.fill", 
                              title: "View Onboarding", 
                              iconColor: .blue,
                              showChevron: false)
                }
                
                Button {
                    showResetConfirmation = true
                } label: {
                    SettingRow(icon: "arrow.counterclockwise", 
                              title: "Reset App", 
                              iconColor: .red,
                              showChevron: false)
                }
            }
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("About")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 1) {
                Link(destination: URL(string: "https://www.example.com/privacy")!) {
                    SettingRow(icon: "lock.fill", 
                              title: "Privacy Policy", 
                              iconColor: .green,
                              showChevron: false)
                }
                
                Divider()
                    .padding(.leading, 56)
                
                Link(destination: URL(string: "https://www.example.com/terms")!) {
                    SettingRow(icon: "doc.text.fill", 
                              title: "Terms of Service", 
                              iconColor: .orange,
                              showChevron: false)
                }
            }
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Support")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 1) {
                Link(destination: URL(string: "mailto:support@example.com")!) {
                    SettingRow(icon: "envelope.fill", 
                              title: "Contact Support", 
                              iconColor: .blue,
                              showChevron: false)
                }
                
                Divider()
                    .padding(.leading, 56)
                
                Link(destination: URL(string: "https://www.example.com/faq")!) {
                    SettingRow(icon: "questionmark.circle.fill", 
                              title: "FAQ", 
                              iconColor: .purple,
                              showChevron: false)
                }
            }
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
    }
    
    private var versionSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Version")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            VStack(spacing: 1) {
                SettingRow(icon: "info.circle.fill", 
                          title: "Version 1.0.0", 
                          iconColor: .gray,
                          showChevron: false)
            }
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    var showChevron: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .font(.system(size: 22))
                .frame(width: 32)
                .padding(.leading, 12)
            
            Text(title)
                .padding(.leading, 12)
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.trailing)
            }
        }
        .frame(height: 44)
    }
}

#Preview {
    SettingsView()
}

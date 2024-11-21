import SwiftUI
import SwiftData
import LocalAuthentication

struct AuthenticationView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AppSettings.language) private var settings: [AppSettings]
    
    @State private var passcode: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    private var currentSettings: AppSettings? {
        settings.first
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "lock.shield")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentColor)
                
                Text("Welcome Back!")
                    .font(.title)
                    .bold()
                
                if currentSettings?.useBiometricAuth ?? false {
                    Button(action: authenticateWithBiometrics) {
                        Label("Use Face ID", systemImage: "faceid")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                }
                
                if currentSettings?.usePasscodeAuth ?? false {
                    SecureField("Enter Passcode", text: $passcode)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                    
                    Button(action: authenticateWithPasscode) {
                        Text("Unlock")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .alert("Authentication Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                if settings.isEmpty {
                    // Create default settings if none exist
                    let defaultSettings = AppSettings()
                    modelContext.insert(defaultSettings)
                }
                
                if !(currentSettings?.useBiometricAuth ?? false) && 
                   !(currentSettings?.usePasscodeAuth ?? false) {
                    // If no authentication method is set up, skip authentication
                    appState.requiresAuthentication = false
                } else if currentSettings?.useBiometricAuth ?? false {
                    authenticateWithBiometrics()
                }
            }
        }
    }
    
    private func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                 localizedReason: "Unlock CountDay") { success, error in
                DispatchQueue.main.async {
                    if success {
                        appState.requiresAuthentication = false
                    } else {
                        showError = true
                        errorMessage = error?.localizedDescription ?? "Authentication failed"
                    }
                }
            }
        } else {
            showError = true
            errorMessage = error?.localizedDescription ?? "Biometric authentication not available"
        }
    }
    
    private func authenticateWithPasscode() {
        guard let savedPasscode = currentSettings?.passcode else {
            showError = true
            errorMessage = "No passcode set"
            return
        }
        
        if passcode == savedPasscode {
            appState.requiresAuthentication = false
        } else {
            showError = true
            errorMessage = "Invalid passcode"
            passcode = ""
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AppState())
        .modelContainer(for: AppSettings.self)
}

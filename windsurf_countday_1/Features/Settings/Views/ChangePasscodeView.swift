import SwiftUI
import SwiftData

struct ChangePasscodeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentPasscode = ""
    @State private var newPasscode = ""
    @State private var confirmPasscode = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    private var currentSettings: AppSettings? {
        settings.first
    }
    
    var body: some View {
        Form {
            if currentSettings?.passcode != nil {
                Section {
                    SecureField("Current Passcode", text: $currentPasscode)
                        .keyboardType(.numberPad)
                }
            }
            
            Section {
                SecureField("New Passcode", text: $newPasscode)
                    .keyboardType(.numberPad)
                SecureField("Confirm New Passcode", text: $confirmPasscode)
                    .keyboardType(.numberPad)
            }
            
            Section {
                Button("Save Changes") {
                    savePasscode()
                }
                .disabled(!canSave)
            }
        }
        .navigationTitle("Change Passcode")
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var canSave: Bool {
        if currentSettings?.passcode != nil && currentPasscode.isEmpty {
            return false
        }
        
        return newPasscode.count >= 4 && newPasscode == confirmPasscode
    }
    
    private func savePasscode() {
        // Validate current passcode if one exists
        if let existingPasscode = currentSettings?.passcode {
            guard currentPasscode == existingPasscode else {
                showError = true
                errorMessage = "Current passcode is incorrect"
                return
            }
        }
        
        // Validate new passcode
        guard newPasscode.count >= 4 else {
            showError = true
            errorMessage = "Passcode must be at least 4 digits"
            return
        }
        
        guard newPasscode == confirmPasscode else {
            showError = true
            errorMessage = "New passcodes do not match"
            return
        }
        
        // Save new passcode
        currentSettings?.passcode = newPasscode
        dismiss()
    }
}

#Preview {
    NavigationView {
        ChangePasscodeView()
            .modelContainer(for: AppSettings.self)
    }
}

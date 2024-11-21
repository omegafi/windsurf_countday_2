import SwiftUI
import SwiftData

struct EditSpecialDayView: View {
    let day: SpecialDay
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var date: Date
    @State private var type: SpecialDayType
    @State private var themeColor: String
    @State private var isCountingForward: Bool
    @State private var notes: String
    @State private var reminderEnabled: Bool
    @State private var reminderDate: Date
    
    init(day: SpecialDay) {
        self.day = day
        _title = State(initialValue: day.title)
        _date = State(initialValue: day.date)
        _type = State(initialValue: day.type)
        _themeColor = State(initialValue: day.themeColor)
        _isCountingForward = State(initialValue: day.isCountingForward)
        _notes = State(initialValue: day.notes ?? "")
        _reminderEnabled = State(initialValue: day.reminderEnabled)
        _reminderDate = State(initialValue: day.reminderDate ?? Date())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Content
                VStack(spacing: 32) {
                    // Basic Info
                    basicInfoSection
                    
                    // Type Info
                    typeSection
                    
                    // Notes
                    notesSection
                    
                    // Reminder
                    reminderSection
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Edit Special Day")
        .navigationBarItems(
            leading: Button("Cancel") { dismiss() },
            trailing: Button("Save") {
                saveChanges()
            }
        )
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: themeColor).opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: type.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(hex: themeColor))
            }
            
            TextField("Title", text: $title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: themeColor).opacity(0.05))
    }
    
    private var basicInfoSection: some View {
        VStack(spacing: 8) {
            if isCountingForward {
                DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .tint(Color(hex: themeColor))
            } else {
                DatePicker("Date", selection: $date, in: Date()..., displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .tint(Color(hex: themeColor))
            }
            
            Toggle("Count Days Forward", isOn: $isCountingForward)
                .tint(Color(hex: themeColor))
                .padding(.top)
                .onChange(of: isCountingForward) { oldValue, newValue in
                    // Tarihi sınırlar içinde tutmak için kontrol
                    if newValue { // İleri sayım
                        if date > Date() {
                            date = Date()
                        }
                    } else { // Geri sayım
                        if date < Date() {
                            date = Date()
                        }
                    }
                }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: themeColor).opacity(0.05))
        )
    }
    
    private var typeSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Type")
                    .font(.headline)
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(SpecialDayType.allCases) { eventType in
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: eventType == type ? themeColor : eventType.defaultColor).opacity(0.2))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: eventType.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: eventType == type ? themeColor : eventType.defaultColor))
                            }
                            
                            Text(eventType.title)
                                .font(.caption)
                                .foregroundColor(eventType == type ? Color(hex: themeColor) : .primary)
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(eventType == type ? Color(hex: themeColor).opacity(0.1) : Color.clear)
                        )
                        .onTapGesture {
                            type = eventType
                            if themeColor == day.themeColor {
                                // Only update color if user hasn't manually changed it
                                themeColor = eventType.defaultColor
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            
            ColorPicker("Theme Color", selection: Binding(
                get: { Color(hex: themeColor) },
                set: { themeColor = $0.toHex() ?? type.defaultColor }
            ))
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Notes", systemImage: "note.text")
                .font(.headline)
            
            TextEditor(text: $notes)
                .frame(height: 100)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    private var reminderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(isOn: $reminderEnabled) {
                Label("Reminder", systemImage: "bell.fill")
                    .font(.headline)
            }
            .tint(Color(hex: themeColor))
            
            if reminderEnabled {
                DatePicker("Reminder Date", selection: $reminderDate, displayedComponents: [.date])
                    .tint(Color(hex: themeColor))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    private func saveChanges() {
        day.updateSpecialDay(
            title: title,
            date: date,
            type: type,
            themeColor: themeColor,
            isCountingForward: isCountingForward,
            notes: notes.isEmpty ? nil : notes,
            reminderEnabled: reminderEnabled,
            reminderDate: reminderEnabled ? reminderDate : nil
        )
        dismiss()
    }
}

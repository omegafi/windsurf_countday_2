import SwiftUI
import SwiftData

struct AddSpecialDayView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var animation
    
    @State private var title = ""
    @State private var date = Date()
    @State private var selectedType = SpecialDayType.birthday
    @State private var isCountingForward = false
    @State private var notes = ""
    @State private var selectedColor = Color.blue
    @State private var showingDatePicker = false
    
    private let backgroundColor = Color(.systemGroupedBackground)
    private let secondaryColor = Color(.secondarySystemGroupedBackground)
    private let accentColor = Color.blue.opacity(0.15)
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    private var dateRange: ClosedRange<Date> {
        if isCountingForward {
            let past = Calendar.current.date(byAdding: .year, value: -100, to: Date()) ?? Date()
            return past...Date()
        } else {
            let future = Calendar.current.date(byAdding: .year, value: 100, to: Date()) ?? Date()
            return Date()...future
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    titleSection
                    countingSection
                    dateSection
                    typeSection
                    colorSection
                    notesSection
                }
                .padding(.vertical)
            }
            .background(backgroundColor)
            .navigationTitle("Add Special Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSpecialDay()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                NavigationStack {
                    DatePicker(
                        "Select Date",
                        selection: $date,
                        in: dateRange,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .navigationTitle("Select Date")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingDatePicker = false
                            }
                        }
                    }
                }
                .presentationDetents([.height(400)])
            }
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Title", icon: "pencil.circle.fill")
            
            TextField("Enter Special Day Name", text: $title)
                .textFieldStyle(.plain)
                .padding()
                .background(secondaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
        }
    }
    
    private var countingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Counting Type", icon: "clock.arrow.circlepath")
            
            HStack(spacing: 0) {
                ForEach([false, true], id: \.self) { isUp in
                    Text(isUp ? "Count Up" : "Count Down")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background {
                            if isUp == isCountingForward {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                        .foregroundStyle(isUp == isCountingForward ? .white : .primary)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.snappy) {
                                isCountingForward = isUp
                                date = Date()
                            }
                        }
                }
            }
            .padding(4)
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }
    
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Date", icon: "calendar.circle.fill")
            
            Button {
                showingDatePicker = true
            } label: {
                HStack {
                    Image(systemName: "calendar")
                        .font(.title3)
                    Text(dateFormatter.string(from: date))
                        .font(.body)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote.bold())
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(secondaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.primary)
            }
            .padding(.horizontal)
        }
    }
    
    private var typeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Type", icon: "tag.circle.fill")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(SpecialDayType.allCases, id: \.self) { type in
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: type.defaultColor).opacity(selectedType == type ? 0.3 : 0.1))
                                    .frame(width: 70, height: 70)
                                
                                Image(systemName: type.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: type.defaultColor))
                            }
                            .scaleEffect(selectedType == type ? 1.1 : 1.0)
                            .animation(.spring(), value: selectedType)
                            
                            Text(type.title)
                                .font(.caption)
                                .foregroundStyle(selectedType == type ? .primary : .secondary)
                        }
                        .onTapGesture {
                            selectedType = type
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Color", icon: "paintpalette.fill")
            
            ColorPicker("", selection: $selectedColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(secondaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Notes", icon: "note.text")
            
            TextEditor(text: $notes)
                .frame(height: 100)
                .padding()
                .background(secondaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
        }
    }
    
    private func saveSpecialDay() {
        let hexColor = convertColorToHex(selectedColor)
        
        let specialDay = SpecialDay(
            title: title,
            date: date,
            type: selectedType,
            themeColor: hexColor,
            isCountingForward: isCountingForward,
            notes: notes.isEmpty ? nil : notes
        )
        
        modelContext.insert(specialDay)
        dismiss()
    }
    
    private func convertColorToHex(_ color: Color) -> String {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return String(format: "#%02X%02X%02X", 
            Int(red * 255), 
            Int(green * 255), 
            Int(blue * 255)
        )
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        Label {
            Text(title)
                .font(.headline)
        } icon: {
            Image(systemName: icon)
                .foregroundStyle(.blue)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddSpecialDayView()
        .modelContainer(try! ModelContainer(for: SpecialDay.self))
}

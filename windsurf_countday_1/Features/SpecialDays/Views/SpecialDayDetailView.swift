import SwiftUI
import SwiftData

struct SpecialDayDetailView: View {
    let day: SpecialDay
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Content
                VStack(spacing: 32) {
                    // Date Info
                    dateSection
                    
                    // Type Info
                    typeSection
                    
                    // Notes
                    if let notes = day.notes, !notes.isEmpty {
                        notesSection(notes)
                    }
                    
                    // Reminder Info
                    if day.reminderEnabled {
                        reminderSection
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: { showingEditSheet = true }) {
                        Image(systemName: "pencil")
                            .foregroundColor(Color(hex: day.themeColor))
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert("Delete Special Day", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                modelContext.delete(day)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete '\(day.title)'? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationView {
                EditSpecialDayView(day: day)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: day.themeColor).opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: day.type.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(hex: day.themeColor))
            }
            
            Text(day.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: day.themeColor).opacity(0.05))
    }
    
    private var dateSection: some View {
        VStack(spacing: 8) {
            Text("\(daysDifference(from: day.date))")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(Color(hex: day.themeColor))
            
            Text(day.isCountingForward ? "days since" : "days left")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text(day.date, style: .date)
                .font(.headline)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: day.themeColor).opacity(0.05))
        )
    }
    
    private var typeSection: some View {
        HStack {
            Label {
                Text(day.type.title)
                    .font(.headline)
            } icon: {
                Image(systemName: day.type.icon)
                    .foregroundColor(Color(hex: day.themeColor))
            }
            
            Spacer()
            
            Circle()
                .fill(Color(hex: day.themeColor))
                .frame(width: 24, height: 24)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    private func notesSection(_ notes: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Notes", systemImage: "note.text")
                .font(.headline)
            
            Text(notes)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    private var reminderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Reminder", systemImage: "bell.fill")
                .font(.headline)
            
            if let reminderDate = day.reminderDate {
                Text(reminderDate, style: .date)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

private func daysDifference(from date: Date) -> Int {
    Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
}

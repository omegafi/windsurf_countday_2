import SwiftUI
import SwiftData

// Görüntüleme modu için enum
enum ViewMode: String, CaseIterable {
    case list, cards, grid
    
    var icon: String {
        switch self {
        case .list: return "list.bullet"
        case .cards: return "square.stack"
        case .grid: return "square.grid.2x2"
        }
    }
    
    var title: String {
        switch self {
        case .list: return "List View"
        case .cards: return "Card View"
        case .grid: return "Grid View"
        }
    }
    
    var nextMode: ViewMode {
        switch self {
        case .list: return .cards
        case .cards: return .grid
        case .grid: return .list
        }
    }
}

// Filtreleme modu için enum
enum FilterMode: String, CaseIterable {
    case all, upcoming, past
    
    var icon: String {
        switch self {
        case .all: return "calendar"
        case .upcoming: return "arrow.forward.circle"
        case .past: return "arrow.backward.circle"
        }
    }
    
    var title: String {
        switch self {
        case .all: return "All Events"
        case .upcoming: return "Upcoming Events"
        case .past: return "Past Events"
        }
    }
    
    var next: FilterMode {
        switch self {
        case .all: return .upcoming
        case .upcoming: return .past
        case .past: return .all
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SpecialDay.date) private var specialDays: [SpecialDay]
    @State private var showingAddSheet = false
    @State private var showSettings = false
    @AppStorage("selectedViewMode") private var selectedViewMode: ViewMode = .cards
    @State private var filterMode: FilterMode = .all
    @State private var selectedSpecialDay: SpecialDay?
    @State private var currentPage = 0
    
    private var filteredDays: [SpecialDay] {
        switch filterMode {
        case .all:
            return specialDays
        case .upcoming:
            return specialDays.filter { !$0.isCountingForward }
        case .past:
            return specialDays.filter { $0.isCountingForward }
        }
    }
    
    private var navigationTitle: String {
        "\(filterMode.title) (\(filteredDays.count))"
    }
    
    private var toolbarColor: Color {
        if let selectedDay = selectedSpecialDay {
            return Color(hex: selectedDay.themeColor).opacity(0.9)
        }
        return .blue
    }
    
    private func cycleViewMode() {
        withAnimation {
            selectedViewMode = selectedViewMode.nextMode
        }
    }
    
    private func cycleFilterMode() {
        withAnimation {
            filterMode = filterMode.next
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredDays.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(toolbarColor)
                        
                        Text("Henüz Hiç Özel Gün Eklenmemiş")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Özel günlerinizi ekleyerek takip etmeye başlayın")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: { showingAddSheet = true }) {
                            Label("Özel Gün Ekle", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(toolbarColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else {
                    switch selectedViewMode {
                    case .cards:
                        TabView(selection: $currentPage) {
                            ForEach(Array(filteredDays.enumerated()), id: \.element.id) { index, day in
                                SpecialDayCardView(day: day)
                                    .tag(index)
                                    .onAppear {
                                        selectedSpecialDay = day
                                    }
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    default:
                        ScrollView {
                            SpecialDaysListView(days: filteredDays, viewMode: selectedViewMode)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(toolbarColor)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: cycleFilterMode) {
                        Image(systemName: filterMode.icon)
                            .foregroundStyle(toolbarColor)
                    }
                    
                    Button(action: cycleViewMode) {
                        Image(systemName: selectedViewMode.icon)
                            .foregroundStyle(toolbarColor)
                    }
                    
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(toolbarColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSpecialDayView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
        .onAppear {
            if !filteredDays.isEmpty {
                selectedSpecialDay = filteredDays[currentPage]
            }
        }
    }
}

struct SpecialDaysListView: View {
    let days: [SpecialDay]
    let viewMode: ViewMode
    
    var body: some View {
        switch viewMode {
        case .list:
            LazyVStack(spacing: 12) {
                ForEach(days) { day in
                    SpecialDayRowView(day: day)
                }
            }
            
        case .cards:
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(days) { day in
                            SpecialDayCardView(day: day)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
            }
            .ignoresSafeArea()
            
        case .grid:
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(days) { day in
                    SpecialDayGridItemView(day: day)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SpecialDay.self)
}

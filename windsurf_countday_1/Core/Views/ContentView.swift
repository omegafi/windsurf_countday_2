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
    
    var nextMode: FilterMode {
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
    
    private func cycleViewMode() {
        withAnimation {
            selectedViewMode = selectedViewMode.nextMode
        }
    }
    
    private func cycleFilterMode() {
        withAnimation {
            filterMode = filterMode.nextMode
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch selectedViewMode {
                case .cards:
                    GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 0) {
                                ForEach(filteredDays) { day in
                                    SpecialDayCardView(day: day)
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                }
                            }
                        }
                        .scrollTargetBehavior(.paging)
                        .ignoresSafeArea()
                    }
                    .ignoresSafeArea()
                default:
                    ScrollView {
                        SpecialDaysListView(days: filteredDays, viewMode: selectedViewMode)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: cycleViewMode) {
                            Image(systemName: selectedViewMode.icon)
                                .imageScale(.large)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .help(selectedViewMode.title)
                        
                        Button(action: cycleFilterMode) {
                            Image(systemName: filterMode.icon)
                                .imageScale(.large)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .help(filterMode.title)
                        
                        Button(action: { showingAddSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(.white.opacity(0.9))
                        }
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
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(days) { day in
                    SpecialDayGridItemView(day: day)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SpecialDay.self)
}

import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProduct: Product?
    @State private var products: [Product] = []
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let productIdentifiers = [
        "com.countday.premium.monthly",
        "com.countday.premium.yearly"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerView
                    
                    // Features
                    featuresView
                    
                    // Products
                    if !products.isEmpty {
                        productsView
                    } else {
                        ProgressView()
                            .padding()
                    }
                    
                    // Footer
                    footerView
                }
                .padding()
            }
            .navigationTitle("Premium Features")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await loadProducts()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Image(systemName: "crown.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("Unlock Premium")
                .font(.title)
                .bold()
            
            Text("Get access to all features and unlimited special days")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
    }
    
    private var featuresView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Premium Features")
                .font(.headline)
            
            ForEach(PremiumFeature.allCases) { feature in
                HStack(spacing: 12) {
                    Image(systemName: feature.icon)
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(feature.title)
                            .font(.subheadline)
                            .bold()
                        
                        Text(feature.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var productsView: some View {
        VStack(spacing: 16) {
            ForEach(products, id: \.id) { product in
                Button {
                    selectedProduct = product
                    Task {
                        await purchase()
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.displayName)
                                .font(.headline)
                            Text(product.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(product.displayPrice)
                            .font(.title3)
                            .bold()
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .buttonStyle(.plain)
                .disabled(isPurchasing)
            }
        }
    }
    
    private var footerView: some View {
        VStack(spacing: 8) {
            Text("Restore Purchases")
                .foregroundColor(.blue)
                .onTapGesture {
                    Task {
                        await restorePurchases()
                    }
                }
            
            Text("Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }
    
    private func loadProducts() async {
        do {
            products = try await Product.products(for: productIdentifiers)
        } catch {
            showError = true
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }
    }
    
    private func purchase() async {
        guard let product = selectedProduct else { return }
        
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    dismiss()
                case .unverified:
                    showError = true
                    errorMessage = "Purchase verification failed"
                }
            case .pending:
                showError = true
                errorMessage = "Purchase is pending"
            case .userCancelled:
                break
            @unknown default:
                showError = true
                errorMessage = "Unknown purchase result"
            }
        } catch {
            showError = true
            errorMessage = "Failed to complete purchase: \(error.localizedDescription)"
        }
    }
    
    private func restorePurchases() async {
        do {
            try await AppStore.sync()
            dismiss()
        } catch {
            showError = true
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
        }
    }
}

enum PremiumFeature: String, CaseIterable, Identifiable {
    case unlimited = "Unlimited Special Days"
    case themes = "Custom Themes"
    case widgets = "Home Screen Widgets"
    case backup = "iCloud Backup"
    case notifications = "Advanced Notifications"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .unlimited: return "infinity.circle.fill"
        case .themes: return "paintbrush.fill"
        case .widgets: return "apps.iphone.fill"
        case .backup: return "icloud.fill"
        case .notifications: return "bell.badge.fill"
        }
    }
    
    var title: String { rawValue }
    
    var description: String {
        switch self {
        case .unlimited:
            return "Track as many special days as you want"
        case .themes:
            return "Personalize your special days with custom themes"
        case .widgets:
            return "Add beautiful widgets to your home screen"
        case .backup:
            return "Keep your data safe with automatic backups"
        case .notifications:
            return "Get reminded with custom notification settings"
        }
    }
}

#Preview {
    PaywallView()
}

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var isAnimating = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    
    var body: some View {
        if isActive {
            if isFirstLaunch {
                OnboardingView()
            } else {
                ContentView()
            }
        } else {
            ZStack {
                Color("SplashBackground")
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "calendar.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.accentColor)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    Text("CountDay")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Track Your Special Moments")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .scaleEffect(0.7)
                .opacity(0.4)
            }
            .onAppear {
                isAnimating = true
                withAnimation(.easeInOut(duration: 1.5)) {
                    // Başlangıç animasyonu
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

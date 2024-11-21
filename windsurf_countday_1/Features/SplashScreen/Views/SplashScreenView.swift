import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @State private var scale: CGFloat = 0.7
    @State private var opacity: CGFloat = 0.4
    @State private var isAnimating = false
    
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
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    isAnimating = true
                    withAnimation(.easeInOut(duration: 0.7)) {
                        scale = 1.0
                        opacity = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        withAnimation(.easeInOut(duration: 0.7)) {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}

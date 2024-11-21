import SwiftUI

struct OnboardingView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @State private var currentPage = 0
    
    let onboardingPages = [
        OnboardingPageData(
            icon: "calendar.badge.plus",
            title: "Track Special Days",
            description: "Easily add and manage your important dates and milestones."
        ),
        OnboardingPageData(
            icon: "clock.fill",
            title: "Count Down or Up",
            description: "Choose to count days since or until a special event."
        ),
        OnboardingPageData(
            icon: "chart.bar.fill",
            title: "Organize Your Memories",
            description: "Keep track of birthdays, anniversaries, and other significant moments."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(onboardingPages.indices, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                HStack {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage = max(0, currentPage - 1)
                            }
                        }) {
                            Text("Previous")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if currentPage < onboardingPages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            withAnimation {
                                isFirstLaunch = false
                            }
                        }
                    }) {
                        Text(currentPage == onboardingPages.count - 1 ? "Get Started" : "Next")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}

struct OnboardingPageData {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPageData
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: page.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }
}

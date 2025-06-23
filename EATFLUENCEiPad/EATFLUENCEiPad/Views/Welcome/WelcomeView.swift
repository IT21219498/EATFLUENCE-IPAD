import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Smooth gradient with your theme colors
            LinearGradient(
                colors: [Color.primaryColor, Color.accentColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .shadow(color: .highlightColor.opacity(0.5), radius: 10, x: 0, y: 5)

                Text("Welcome to EATFLUENCE!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)

                Text("Discover, share, and enjoy amazing food experiences.")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: {
                    // Handle navigation to main app
                    print("Get Started tapped")
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.backgroundColor.opacity(0.8))
                        .foregroundColor(.primaryColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 60)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

                Spacer()
            }
            .padding(.top, 80)
        }
    }
}

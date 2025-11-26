import SwiftUI
import AVFoundation

struct SplashScreen: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @State private var animationOffset: CGFloat = 0
    @State private var gradientPhase: CGFloat = 0
    @State private var showStartButton = false
    
    var body: some View {
        ZStack {
            // Animated gradient background with vibrant colors
            LinearGradient(
                colors: [Theme.Colors.vibrantOrange, Theme.Colors.lightOrange, 
                        Theme.Colors.vibrantBlue, Theme.Colors.deepBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .hueRotation(.degrees(gradientPhase * 360))
            .ignoresSafeArea()
            
            // Subtle star field animation
            StarField()
            
            // Floating light particles
            FloatingParticles()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Floating boy image
                Image("boy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .offset(y: animationOffset)
                    .shadow(color: .black.opacity(0.3), radius: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // App title with enhanced styling
                Text("KIDDIVERSE")
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundStyle(
                        LinearGradient(colors: [.white, .white.opacity(0.9)], 
                                     startPoint: .top, endPoint: .bottom)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 5)
                
                // Progress dots
                LoadingDots()
                
                Spacer()
                
                // Start button (appears after 2.5 seconds)
                if showStartButton {
                    GlassCard {
                        Button(action: {
                            coordinator.push(.dashboard)
                        }) {
                            Text("Start Adventure")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                        }
                    }
                    .scaleEffect(showStartButton ? 1.0 : 0.8)
                    .animation(.spring(response: 0.5), value: showStartButton)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            autoNavigate()
        }
    }
    
    private func startAnimations() {
        // Enhanced float animation with rotation
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            animationOffset = -30
        }
        // Slower gradient animation for subtle effect
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            gradientPhase = 1
        }
    }
    
    private func autoNavigate() {
        // Show start button after 2.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                showStartButton = true
            }
        }
        
        // Auto-navigate after 5 seconds total
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if coordinator.path.isEmpty {
                coordinator.push(.dashboard)
            }
        }
    }
}

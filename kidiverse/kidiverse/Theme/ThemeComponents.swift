import SwiftUI

struct Theme {
    struct Colors {
        static let mint = Color(red: 0.706, green: 0.973, blue: 0.784)
        static let peach = Color(red: 1.0, green: 0.839, blue: 0.714)
        static let lavender = Color(red: 0.878, green: 0.839, blue: 1.0)
        static let skyBlue = Color(red: 0.529, green: 0.808, blue: 0.922)
        static let softSun = Color(red: 1.0, green: 0.957, blue: 0.714)
        
        // Splash screen gradient colors
        static let vibrantOrange = Color(red: 1.0, green: 0.439, blue: 0.263)
        static let lightOrange = Color(red: 1.0, green: 0.655, blue: 0.149)
        static let vibrantBlue = Color(red: 0.259, green: 0.647, blue: 0.960)
        static let deepBlue = Color(red: 0.129, green: 0.588, blue: 0.953)
    }
    
    struct Spacing {
        static let small: CGFloat = 10
        static let medium: CGFloat = 20
        static let large: CGFloat = 40
        static let xlarge: CGFloat = 60
    }
}

struct GlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.6),
                                        .white.opacity(0.2),
                                        .clear,
                                        .black.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .shadow(color: .white.opacity(0.3), radius: 20)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct PremiumGlassCard<Content: View>: View {
    let content: Content
    let accentColor: Color
    
    init(accentColor: Color = .blue, @ViewBuilder content: () -> Content) {
        self.accentColor = accentColor
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 35)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        accentColor.opacity(0.8),
                                        accentColor.opacity(0.4),
                                        .white.opacity(0.3),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: accentColor.opacity(0.3), radius: 15, x: 0, y: 8)
            )
            .shadow(color: accentColor.opacity(0.4), radius: 25)
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 12)
    }
}

struct AnimatedGradientBackground: View {
    @Binding var phase: CGFloat
    
    var body: some View {
        LinearGradient(
            colors: [Theme.Colors.mint, Theme.Colors.peach, 
                    Theme.Colors.lavender, Theme.Colors.skyBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .hueRotation(.degrees(phase * 360))
        .ignoresSafeArea()
    }
}

struct GradientBackground: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        LinearGradient(
            colors: [Theme.Colors.mint, Theme.Colors.peach, 
                    Theme.Colors.lavender, Theme.Colors.skyBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .hueRotation(.degrees(phase * 360))
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

struct LoadingDots: View {
    @State private var animationPhase = 0
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
                    .scaleEffect(animationPhase == index ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 0.6).repeatForever().delay(Double(index) * 0.2), value: animationPhase)
            }
        }
        .onAppear {
            withAnimation {
                animationPhase = 1
            }
        }
    }
}

struct FloatingParticles: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var speed: Double
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
            }
        }
        .onAppear {
            createParticles()
            animateParticles()
        }
    }
    
    private func createParticles() {
        for _ in 0..<20 {
            particles.append(Particle(
                x: CGFloat.random(in: 0...1920),
                y: CGFloat.random(in: 0...1080),
                size: CGFloat.random(in: 4...12),
                speed: Double.random(in: 1...3)
            ))
        }
    }
    
    private func animateParticles() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in particles.indices {
                particles[i].y -= particles[i].speed
                if particles[i].y < -50 {
                    particles[i].y = 1130
                    particles[i].x = CGFloat.random(in: 0...1920)
                }
            }
        }
    }
}

struct StarField: View {
    @State private var stars: [Star] = []
    
    struct Star: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var twinkleSpeed: Double
        var rotation: Double
    }
    
    var body: some View {
        ZStack {
            ForEach(stars) { star in
                Image(systemName: "star.fill")
                    .font(.system(size: star.size))
                    .foregroundColor(.white)
                    .opacity(star.opacity)
                    .rotationEffect(.degrees(star.rotation))
                    .position(x: star.x, y: star.y)
                    .animation(.easeInOut(duration: star.twinkleSpeed).repeatForever(autoreverses: true), value: star.opacity)
                    .animation(.linear(duration: star.twinkleSpeed * 2).repeatForever(autoreverses: false), value: star.rotation)
            }
        }
        .onAppear {
            createStars()
            animateStars()
        }
    }
    
    private func createStars() {
        for _ in 0..<30 {
            stars.append(Star(
                x: CGFloat.random(in: 0...1920),
                y: CGFloat.random(in: 0...1080),
                size: CGFloat.random(in: 8...24),
                opacity: Double.random(in: 0.3...1.0),
                twinkleSpeed: Double.random(in: 1...3),
                rotation: Double.random(in: 0...360)
            ))
        }
    }
    
    private func animateStars() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in stars.indices {
                // Slowly rotate stars
                stars[i].rotation += 0.5
                if stars[i].rotation >= 360 {
                    stars[i].rotation = 0
                }
                
                // Occasionally change opacity for twinkle effect
                if Bool.random() {
                    stars[i].opacity = Double.random(in: 0.3...1.0)
                }
            }
        }
    }
}

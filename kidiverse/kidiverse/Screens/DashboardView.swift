import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject var viewModel = DashboardViewModel()
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            // Animated background
            GradientBackground()
            FloatingParticles()
            
            VStack(spacing: 60) {
                // Welcome header
                Text("What do you want to learn today?")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5)
                
                // Card carousel
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 40) {
                        ForEach(viewModel.cards) { card in
                            DashboardCardView(card: card)
                                .onTapGesture {
                                    coordinator.push(card.route)
                                }
                        }
                    }
                    .padding(.horizontal, 100)
                }
            }
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Optional: Add settings or profile
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct DashboardCardView: View {
    let card: DashboardViewModel.DashboardCard
    @FocusState private var isFocused: Bool
    
    var body: some View {
        GlassCard {
            VStack(spacing: 20) {
                Text(card.emoji)
                    .font(.system(size: 100))
                
                Image(systemName: card.icon)
                    .font(.system(size: 60))
                    .foregroundColor(card.color)
                
                Text(card.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 400, height: 400)
        }
        .scaleEffect(isFocused ? 1.1 : 1.0)
        .shadow(color: isFocused ? card.color.opacity(0.6) : .clear, radius: 20)
        .animation(.spring(response: 0.3), value: isFocused)
        .focusable()
        .focused($isFocused)
    }
}

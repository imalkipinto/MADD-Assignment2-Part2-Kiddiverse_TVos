import SwiftUI

struct GoodVsBadView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject var viewModel = GoodVsBadViewModel()
    
    var body: some View {
        ZStack {
            // Background
            GradientBackground()
            
            VStack(spacing: 40) {
                // Header
                HStack {
                    Button(action: {
                        if viewModel.selectedBehavior != nil || viewModel.selectedCategory != nil {
                            viewModel.goBack()
                        } else {
                            coordinator.pop()
                        }
                    }) {
                        GlassCard {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                                .padding(20)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Good vs Bad")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    GlassCard {
                        Text(viewModel.selectedCategory == true ? "😊" : 
                             viewModel.selectedCategory == false ? "😞" : "🤔")
                            .font(.system(size: 40))
                    }
                }
                .padding(.horizontal, 40)
                
                // Main content
                if let category = viewModel.selectedCategory {
                    // Show behaviors for selected category
                    BehaviorsListView(isGood: category, behaviors: category ? viewModel.goodBehaviors : viewModel.badBehaviors)
                } else {
                    // Show main category selection
                    CategorySelectionView()
                }
                
                // Feedback overlay
                if viewModel.showFeedback, let behavior = viewModel.selectedBehavior {
                    GlassCard {
                        VStack(spacing: 20) {
                            Text(behavior.isGood ? "👍" : "👎")
                                .font(.system(size: 100))
                                .scaleEffect(viewModel.showFeedback ? 1.2 : 1.0)
                                .animation(.spring(response: 0.5), value: viewModel.showFeedback)
                            
                            Text(behavior.isGood ? "Great Choice!" : "Not So Good!")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(behavior.isGood ? .green : .red)
                            
                            Text(behavior.title)
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .frame(width: 500, height: 250)
                    .scaleEffect(viewModel.showFeedback ? 1.1 : 1.0)
                    .shadow(color: behavior.isGood ? .green.opacity(0.6) : .red.opacity(0.6), radius: 20)
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct CategorySelectionView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject var viewModel = GoodVsBadViewModel()
    
    var body: some View {
        HStack(spacing: 60) {
            // Good behavior card
            GlassCard {
                VStack(spacing: 30) {
                    Text("😊")
                        .font(.system(size: 120))
                    
                    Text("Good Behavior")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("Sharing, Helping, Kindness")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .frame(width: 400, height: 400)
            }
            .onTapGesture {
                viewModel.selectCategory(true)
            }
            
            // Bad behavior card
            GlassCard {
                VStack(spacing: 30) {
                    Text("😞")
                        .font(.system(size: 120))
                    
                    Text("Bad Behavior")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.red)
                    
                    Text("Lying, Bullying, Littering")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .frame(width: 400, height: 400)
            }
            .onTapGesture {
                viewModel.selectCategory(false)
            }
        }
    }
}

struct BehaviorsListView: View {
    let isGood: Bool
    let behaviors: [GoodVsBadViewModel.Behavior]
    @StateObject var viewModel = GoodVsBadViewModel()
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 40),
            GridItem(.flexible(), spacing: 40)
        ], spacing: 40) {
            ForEach(behaviors) { behavior in
                BehaviorCardView(behavior: behavior)
                    .onTapGesture {
                        viewModel.selectBehavior(behavior)
                    }
            }
        }
        .padding(.horizontal, 60)
    }
}

struct BehaviorCardView: View {
    let behavior: GoodVsBadViewModel.Behavior
    @FocusState private var isFocused: Bool
    
    var body: some View {
        GlassCard {
            VStack(spacing: 20) {
                Text(behavior.emoji)
                    .font(.system(size: 80))
                
                Image(systemName: behavior.icon)
                    .font(.system(size: 50))
                    .foregroundColor(behavior.isGood ? .green : .red)
                
                Text(behavior.title)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 300, height: 280)
        }
        .scaleEffect(isFocused ? 1.1 : 1.0)
        .shadow(color: isFocused ? (behavior.isGood ? .green.opacity(0.6) : .red.opacity(0.6)) : .clear, radius: 20)
        .animation(.spring(response: 0.3), value: isFocused)
        .focusable()
        .focused($isFocused)
    }
}

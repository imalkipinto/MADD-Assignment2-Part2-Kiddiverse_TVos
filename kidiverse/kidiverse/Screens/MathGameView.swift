import SwiftUI

struct MathGameView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject var viewModel = MathViewModel()
    
    var body: some View {
        ZStack {
            // Background
            GradientBackground()
            
            VStack(spacing: 40) {
                // Header with back button and score
                HStack {
                    Button(action: {
                        coordinator.pop()
                    }) {
                        GlassCard {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                                .padding(20)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Math Game")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    GlassCard {
                        Text("Score: \(viewModel.score)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                    }
                }
                .padding(.horizontal, 40)
                
                if let question = viewModel.currentQuestion {
                    // Question display
                    GlassCard {
                        VStack(spacing: 20) {
                            Text("\(question.num1) \(question.operation) \(question.num2) = ?")
                                .font(.system(size: 80, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 500, height: 150)
                    
                    // Feedback overlay
                    if viewModel.showFeedback {
                        GlassCard {
                            VStack(spacing: 20) {
                                Text(viewModel.feedbackMessage)
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(viewModel.isCorrect ? .green : .red)
                                
                                if viewModel.isCorrect {
                                    Text("🎉")
                                        .font(.system(size: 80))
                                        .scaleEffect(viewModel.showFeedback ? 1.2 : 1.0)
                                        .animation(.spring(response: 0.5), value: viewModel.showFeedback)
                                }
                            }
                        }
                        .frame(width: 500, height: 150)
                        .scaleEffect(viewModel.showFeedback ? 1.1 : 1.0)
                        .shadow(color: viewModel.isCorrect ? .green.opacity(0.6) : .red.opacity(0.6), radius: 20)
                    }
                    
                    // Answer options
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 30),
                        GridItem(.flexible(), spacing: 30)
                    ], spacing: 30) {
                        ForEach(question.options, id: \.self) { option in
                            MathAnswerButton(answer: option) {
                                if !viewModel.showFeedback {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.checkAnswer(option)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                }
                
                // Game completion
                if viewModel.currentIndex >= 10 {
                    GlassCard {
                        VStack(spacing: 30) {
                            Text("🎊")
                                .font(.system(size: 100))
                            
                            Text("Math Master!")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Final Score: \(viewModel.score) points")
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Button(action: {
                                viewModel.reset()
                            }) {
                                GlassCard {
                                    Text("Play Again")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 40)
                                        .padding(.vertical, 20)
                                }
                            }
                        }
                        .padding(40)
                    }
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct MathAnswerButton: View {
    let answer: Int
    let action: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        GlassCard {
            Button(action: action) {
                Text("\(answer)")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 150, height: 100)
            }
        }
        .scaleEffect(isFocused ? 1.1 : 1.0)
        .shadow(color: isFocused ? .white.opacity(0.4) : .clear, radius: 15)
        .animation(.spring(response: 0.3), value: isFocused)
        .focusable()
        .focused($isFocused)
    }
}

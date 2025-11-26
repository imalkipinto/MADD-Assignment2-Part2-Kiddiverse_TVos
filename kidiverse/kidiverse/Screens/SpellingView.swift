import SwiftUI

struct SpellingView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject var viewModel = SpellingViewModel()
    @State private var celebrationAnimation: CGFloat = 0
    
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
                    
                    Text("Spelling Fun")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    GlassCard {
                        Text("\(viewModel.score)/\(viewModel.totalWords)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                    }
                }
                .padding(.horizontal, 40)
                
                if let currentWord = viewModel.currentWord {
                    // Word image display (NEW)
                    WordImageView(word: currentWord)
                        .frame(height: 250)
                    
                    // Word display
                    GlassCard {
                        Text(currentWord.display)
                            .font(.system(size: 120, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .tracking(10)
                    }
                    .frame(width: 600, height: 200)
                    
                    // Enhanced feedback overlay
                    if viewModel.showFeedback {
                        FeedbackView(isCorrect: viewModel.isCorrect, message: viewModel.feedbackMessage)
                    }
                    
                    // Letter options
                    HStack(spacing: 30) {
                        ForEach(Array(currentWord.options.enumerated()), id: \.offset) { index, letter in
                            LetterButton(letter: letter, isDisabled: viewModel.showFeedback) {
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.checkAnswer(letter)
                                }
                            }
                        }
                    }
                }
                
                // Enhanced game completion
                if viewModel.currentIndex >= viewModel.totalWords {
                    GameCompletionView(score: viewModel.score, totalWords: viewModel.totalWords) {
                        viewModel.reset()
                    }
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
        .overlay(
            // Congratulations overlay (NEW)
            CongratulationsOverlay(show: viewModel.showCongratulations)
        )
    }
}

struct LetterButton: View {
    let letter: Character
    let isDisabled: Bool
    let action: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        GlassCard {
            Button(action: action) {
                Text(String(letter))
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(isDisabled ? .gray : .white)
                    .frame(width: 100, height: 100)
            }
            .disabled(isDisabled)
        }
        .scaleEffect(isFocused ? 1.1 : 1.0)
        .shadow(color: isFocused ? .white.opacity(0.4) : .clear, radius: 15)
        .animation(.spring(response: 0.3), value: isFocused)
        .focusable()
        .focused($isFocused)
    }
}

// MARK: - Word Image View (NEW)
struct WordImageView: View {
    let word: SpellingViewModel.SpellingWord
    
    var body: some View {
        GlassCard {
            VStack(spacing: 20) {
                // Try to load image, fallback to emoji
                Group {
                    if UIImage(named: word.imageName) != nil {
                        Image(word.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        // Professional emoji fallback with background
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Theme.Colors.peach.opacity(0.3))
                                .frame(width: 180, height: 180)
                            
                            Text(word.emoji)
                                .font(.system(size: 100))
                        }
                    }
                }
                
                Text("What's this word?")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(30)
        }
        .frame(height: 250)
    }
}

// MARK: - Feedback View (NEW)
struct FeedbackView: View {
    let isCorrect: Bool
    let message: String
    @State private var bounceScale: CGFloat = 0
    
    var body: some View {
        GlassCard {
            VStack(spacing: 20) {
                Text(message)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(isCorrect ? .green : .red)
                
                if isCorrect {
                    Text("🎉")
                        .font(.system(size: 80))
                        .scaleEffect(bounceScale)
                        .animation(.spring(response: 0.5), value: bounceScale)
                        .onAppear {
                            bounceScale = 1.3
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                bounceScale = 1.0
                            }
                        }
                } else {
                    Text("💪")
                        .font(.system(size: 80))
                        .rotationEffect(.degrees(bounceScale))
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: bounceScale)
                        .onAppear {
                            bounceScale = 10
                        }
                }
            }
        }
        .frame(width: 450, height: 180)
        .scaleEffect(isCorrect ? 1.1 : 1.05)
        .shadow(color: isCorrect ? .green.opacity(0.6) : .red.opacity(0.6), radius: 20)
    }
}

// MARK: - Congratulations Overlay (NEW)
struct CongratulationsOverlay: View {
    let show: Bool
    @State private var confettiOffset: CGFloat = 0
    @State private var starRotation: Double = 0
    
    var body: some View {
        ZStack {
            if show {
                // Semi-transparent overlay
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Animated stars
                    HStack(spacing: 20) {
                        ForEach(0..<5) { index in
                            Image(systemName: "star.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.yellow)
                                .rotationEffect(.degrees(starRotation + Double(index * 72)))
                                .offset(y: confettiOffset)
                        }
                    }
                    
                    // Congratulations message
                    GlassCard {
                        VStack(spacing: 30) {
                            Text("🎊")
                                .font(.system(size: 120))
                                .scaleEffect(show ? 1.2 : 1.0)
                                .animation(.spring(response: 0.6), value: show)
                            
                            Text("CONGRATULATIONS!")
                                .font(.system(size: 48, weight: .heavy))
                                .foregroundStyle(
                                    LinearGradient(colors: [.yellow, .orange], 
                                                 startPoint: .leading, endPoint: .trailing)
                                )
                            
                            Text("Great spelling!")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(40)
                    }
                    .scaleEffect(show ? 1.1 : 1.0)
                    .shadow(color: .yellow.opacity(0.6), radius: 30)
                }
            }
        }
        .onAppear {
            if show {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    confettiOffset = -20
                }
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    starRotation = 360
                }
            }
        }
    }
}

// MARK: - Game Completion View (NEW)
struct GameCompletionView: View {
    let score: Int
    let totalWords: Int
    let onPlayAgain: () -> Void
    @State private var celebrationScale: CGFloat = 0
    
    var body: some View {
        GlassCard {
            VStack(spacing: 40) {
                Text("🏆")
                    .font(.system(size: 120))
                    .scaleEffect(celebrationScale)
                    .onAppear {
                        withAnimation(.spring(response: 0.8)) {
                            celebrationScale = 1.2
                        }
                    }
                
                Text("Amazing!")
                    .font(.system(size: 56, weight: .heavy))
                    .foregroundStyle(
                        LinearGradient(colors: [.yellow, .orange], 
                                     startPoint: .leading, endPoint: .trailing)
                    )
                
                VStack(spacing: 20) {
                    Text("Final Score")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(score)/\(totalWords)")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Button(action: onPlayAgain) {
                    GlassCard {
                        Text("Play Again")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 25)
                    }
                }
            }
            .padding(50)
        }
        .scaleEffect(celebrationScale)
        .shadow(color: .yellow.opacity(0.6), radius: 30)
    }
}

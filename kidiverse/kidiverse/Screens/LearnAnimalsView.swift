import SwiftUI

struct LearnAnimalsView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject var viewModel = AnimalsViewModel()
    
    var body: some View {
        ZStack {
            // Background
            GradientBackground()
            
            VStack(spacing: 40) {
                // Header with back button
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
                    
                    Text("Learn Animals")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
                
                // Animal grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 40),
                    GridItem(.flexible(), spacing: 40),
                    GridItem(.flexible(), spacing: 40)
                ], spacing: 40) {
                    ForEach(viewModel.animals) { animal in
                        AnimalCardView(animal: animal, isSelected: viewModel.selectedAnimal?.id == animal.id)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.selectAnimal(animal)
                                }
                            }
                    }
                }
                .padding(.horizontal, 60)
                
                // Selected animal display
                if let selectedAnimal = viewModel.selectedAnimal {
                    GlassCard {
                        VStack(spacing: 20) {
                            Text(selectedAnimal.emoji)
                                .font(.system(size: 120))
                            
                            Text(selectedAnimal.name)
                                .font(.system(size: 64, weight: .bold))
                                .foregroundColor(.white)
                            
                            if viewModel.isPlayingSound {
                                HStack {
                                    ForEach(0..<3) { _ in
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .animation(.easeInOut(duration: 0.5).repeatForever(), value: viewModel.isPlayingSound)
                            }
                        }
                        .padding(40)
                    }
                    .scaleEffect(1.1)
                    .shadow(color: Theme.Colors.mint.opacity(0.6), radius: 20)
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct AnimalCardView: View {
    let animal: AnimalsViewModel.Animal
    let isSelected: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        GlassCard {
            VStack(spacing: 20) {
                // Animal image or emoji fallback
                Group {
                    if UIImage(named: animal.imageName) != nil {
                        Image(animal.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        Text(animal.emoji)
                            .font(.system(size: 100))
                    }
                }
                
                Text(animal.name)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: 250, height: 250)
        }
        .scaleEffect(isFocused ? 1.1 : (isSelected ? 1.05 : 1.0))
        .shadow(color: isSelected ? Theme.Colors.mint.opacity(0.8) : (isFocused ? .white.opacity(0.4) : .clear), radius: 20)
        .animation(.spring(response: 0.3), value: isFocused)
        .animation(.spring(response: 0.5), value: isSelected)
        .focusable()
        .focused($isFocused)
    }
}

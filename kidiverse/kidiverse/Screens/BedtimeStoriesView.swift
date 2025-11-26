import SwiftUI

struct BedtimeStoriesView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @StateObject var viewModel = StoriesViewModel()
    
    var body: some View {
        ZStack {
            // Background
            GradientBackground()
            
            VStack(spacing: 40) {
                // Header
                HStack {
                    Button(action: {
                        if viewModel.selectedStory != nil {
                            viewModel.goBackToStories()
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
                    
                    Text(viewModel.selectedStory != nil ? viewModel.selectedStory!.title : "Bedtime Stories")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    if viewModel.selectedStory != nil {
                        GlassCard {
                            Text("\(viewModel.currentPage + 1)/\(viewModel.selectedStory!.pages.count)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                if let story = viewModel.selectedStory {
                    // Story reader view
                    StoryReaderView(story: story)
                } else {
                    // Stories list view
                    StoriesListView()
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct StoriesListView: View {
    @StateObject var viewModel = StoriesViewModel()
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 40),
            GridItem(.flexible(), spacing: 40),
            GridItem(.flexible(), spacing: 40)
        ], spacing: 40) {
            ForEach(viewModel.stories) { story in
                StoryCardView(story: story)
                    .onTapGesture {
                        viewModel.selectStory(story)
                    }
            }
        }
        .padding(.horizontal, 60)
    }
}

struct StoryCardView: View {
    let story: StoriesViewModel.Story
    @FocusState private var isFocused: Bool
    
    var body: some View {
        GlassCard {
            VStack(spacing: 20) {
                // Story thumbnail or placeholder
                Group {
                    if UIImage(named: story.thumbnail) != nil {
                        Image(story.thumbnail)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    } else {
                        // Placeholder with story icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Theme.Colors.lavender.opacity(0.3))
                                .frame(width: 200, height: 150)
                            
                            Image(systemName: "book.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Theme.Colors.lavender)
                        }
                    }
                }
                
                Text(story.title)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("\(story.pages.count) pages")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(width: 300, height: 350)
        }
        .scaleEffect(isFocused ? 1.1 : 1.0)
        .shadow(color: isFocused ? Theme.Colors.skyBlue.opacity(0.6) : .clear, radius: 20)
        .animation(.spring(response: 0.3), value: isFocused)
        .focusable()
        .focused($isFocused)
    }
}

struct StoryReaderView: View {
    let story: StoriesViewModel.Story
    @StateObject var viewModel = StoriesViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            // Story illustration or placeholder
            Group {
                if let illustration = story.pages[viewModel.currentPage].illustration,
                   UIImage(named: illustration) != nil {
                    Image(illustration)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    // Placeholder illustration
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Theme.Colors.skyBlue.opacity(0.2))
                            .frame(height: 300)
                        
                        Image(systemName: "book.fill")
                            .font(.system(size: 100))
                            .foregroundColor(Theme.Colors.skyBlue)
                    }
                }
            }
            
            // Story text
            GlassCard {
                Text(story.pages[viewModel.currentPage].text)
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(5)
                    .padding(40)
            }
            .frame(maxWidth: 800)
            
            // Navigation controls
            HStack(spacing: 40) {
                // Previous button
                GlassCard {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.previousPage()
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24))
                            Text("Previous")
                                .font(.system(size: 28, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                    }
                }
                .disabled(viewModel.currentPage == 0)
                .opacity(viewModel.currentPage == 0 ? 0.5 : 1.0)
                
                // Auto-advance toggle
                GlassCard {
                    Button(action: {
                        viewModel.toggleAutoAdvance()
                    }) {
                        HStack {
                            Image(systemName: viewModel.autoAdvance ? "pause.fill" : "play.fill")
                                .font(.system(size: 24))
                            Text(viewModel.autoAdvance ? "Auto" : "Play")
                                .font(.system(size: 28, weight: .semibold))
                        }
                        .foregroundColor(viewModel.autoAdvance ? .green : .white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                    }
                }
                
                // Next button
                GlassCard {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            viewModel.nextPage()
                        }
                    }) {
                        HStack {
                            Text("Next")
                                .font(.system(size: 28, weight: .semibold))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 24))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                    }
                }
                .disabled(viewModel.currentPage >= story.pages.count - 1)
                .opacity(viewModel.currentPage >= story.pages.count - 1 ? 0.5 : 1.0)
            }
            
            // Story completion
            if viewModel.currentPage >= story.pages.count - 1 {
                GlassCard {
                    VStack(spacing: 20) {
                        Text("🌟")
                            .font(.system(size: 80))
                        
                        Text("Story Complete!")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Button(action: {
                            viewModel.goBackToStories()
                        }) {
                            GlassCard {
                                Text("More Stories")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                            }
                        }
                    }
                    .padding(30)
                }
            }
        }
        .padding(.horizontal, 60)
    }
}

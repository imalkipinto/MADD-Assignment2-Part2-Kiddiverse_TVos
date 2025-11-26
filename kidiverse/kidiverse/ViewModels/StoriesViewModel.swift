import SwiftUI
import Foundation

class StoriesViewModel: ObservableObject {
    struct Story: Identifiable {
        let id = UUID()
        let title: String
        let thumbnail: String
        let pages: [StoryPage]
    }
    
    struct StoryPage {
        let text: String
        let illustration: String?
    }
    
    @Published var selectedStory: Story?
    @Published var currentPage = 0
    @Published var autoAdvance = false
    @Published var isAutoAdvancing = false
    
    let stories = [
        Story(title: "The Sleepy Moon", thumbnail: "story1", pages: [
            StoryPage(text: "Once upon a time, the moon was very sleepy. It had been shining all night and wanted to rest.", illustration: "moon1"),
            StoryPage(text: "The moon yawned a big, sleepy yawn. Its light grew dimmer and dimmer.", illustration: "moon2"),
            StoryPage(text: "The stars noticed the moon was tired. They twinkled softly to say goodnight.", illustration: "stars"),
            StoryPage(text: "The moon closed its eyes and drifted off to sleep, dreaming of sunny days.", illustration: "sleep"),
            StoryPage(text: "And so the moon slept peacefully until it was time to shine again. The end!", illustration: "peace")
        ]),
        Story(title: "The Magic Forest", thumbnail: "story2", pages: [
            StoryPage(text: "Deep in the forest, there was a magical place where animals could talk.", illustration: "forest1"),
            StoryPage(text: "A little bunny named Lily discovered the secret path to this magical forest.", illustration: "bunny"),
            StoryPage(text: "The wise old owl greeted Lily and showed her around the enchanted woods.", illustration: "owl"),
            StoryPage(text: "Lily made friends with squirrels, deer, and even a friendly bear!", illustration: "friends"),
            StoryPage(text: "Every day, Lily visited her forest friends for wonderful adventures. The end!", illustration: "adventure")
        ]),
        Story(title: "The Friendly Dragon", thumbnail: "story3", pages: [
            StoryPage(text: "In a land far away, there lived a dragon named Spark who was very friendly.", illustration: "dragon1"),
            StoryPage(text: "Unlike other dragons, Spark didn't breathe fire. He breathed colorful bubbles!", illustration: "bubbles"),
            StoryPage(text: "The children in the village loved to play with Spark and his magical bubbles.", illustration: "children"),
            StoryPage(text: "Spark protected the village and helped everyone with his bubble magic.", illustration: "protect"),
            StoryPage(text: "And so, Spark the bubble-breathing dragon became the village's best friend. The end!", illustration: "friendship")
        ])
    ]
    
    func selectStory(_ story: Story) {
        selectedStory = story
        currentPage = 0
        stopAutoAdvance()
    }
    
    func nextPage() {
        guard let story = selectedStory else { return }
        if currentPage < story.pages.count - 1 {
            currentPage += 1
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
    func toggleAutoAdvance() {
        autoAdvance.toggle()
        if autoAdvance {
            startAutoAdvance()
        } else {
            stopAutoAdvance()
        }
    }
    
    private func startAutoAdvance() {
        isAutoAdvancing = true
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            if !self.autoAdvance {
                timer.invalidate()
                self.isAutoAdvancing = false
                return
            }
            
            if let story = self.selectedStory {
                if self.currentPage < story.pages.count - 1 {
                    self.currentPage += 1
                } else {
                    self.autoAdvance = false
                    timer.invalidate()
                    self.isAutoAdvancing = false
                }
            }
        }
    }
    
    private func stopAutoAdvance() {
        autoAdvance = false
        isAutoAdvancing = false
    }
    
    func goBackToStories() {
        selectedStory = nil
        currentPage = 0
        stopAutoAdvance()
    }
}

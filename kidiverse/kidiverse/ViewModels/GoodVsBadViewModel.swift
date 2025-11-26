import SwiftUI
import AVFoundation

class GoodVsBadViewModel: ObservableObject {
    struct Behavior: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let emoji: String
        let isGood: Bool
    }
    
    @Published var selectedCategory: Bool? // true = good, false = bad
    @Published var selectedBehavior: Behavior?
    @Published var showFeedback = false
    
    let goodBehaviors = [
        Behavior(title: "Sharing Toys", icon: "gift.fill", emoji: "🎁", isGood: true),
        Behavior(title: "Helping Others", icon: "hands.sparkles.fill", emoji: "🤝", isGood: true),
        Behavior(title: "Being Kind", icon: "heart.fill", emoji: "❤️", isGood: true),
        Behavior(title: "Cleaning Up", icon: "sparkles", emoji: "✨", isGood: true)
    ]
    
    let badBehaviors = [
        Behavior(title: "Telling Lies", icon: "exclamationmark.triangle.fill", emoji: "🤥", isGood: false),
        Behavior(title: "Being Mean", icon: "hand.raised.slash.fill", emoji: "😠", isGood: false),
        Behavior(title: "Littering", icon: "trash.fill", emoji: "🗑️", isGood: false),
        Behavior(title: "Yelling", icon: "speaker.wave.3.fill", emoji: "📢", isGood: false)
    ]
    
    func selectCategory(_ isGood: Bool) {
        selectedCategory = isGood
        selectedBehavior = nil
    }
    
    func selectBehavior(_ behavior: Behavior) {
        selectedBehavior = behavior
        playFeedback(isGood: behavior.isGood)
        showFeedback = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showFeedback = false
        }
    }
    
    func goBack() {
        if selectedBehavior != nil {
            selectedBehavior = nil
        } else {
            selectedCategory = nil
        }
    }
    
    private func playFeedback(isGood: Bool) {
        // Play different system sounds for good vs bad
        if isGood {
            AudioServicesPlaySystemSound(1015) // Positive sound
        } else {
            AudioServicesPlaySystemSound(1071) // Negative sound
        }
    }
}

import SwiftUI
import Foundation

class SpellingViewModel: ObservableObject {
    struct SpellingWord {
        let word: String
        let display: String // "C_T"
        let missingIndex: Int
        let options: [Character]
        let imageName: String // Image for the word
        let emoji: String // Fallback emoji
    }
    
    @Published var currentWord: SpellingWord?
    @Published var score = 0
    @Published var totalWords = 10
    @Published var currentIndex = 0
    @Published var showFeedback = false
    @Published var isCorrect = false
    @Published var feedbackMessage = ""
    @Published var showCongratulations = false
    
    private let wordsWithImages = [
        ("CAT", "cat", "🐱"),
        ("DOG", "dog", "🐶"),
        ("SUN", "sun", "☀️"),
        ("BAT", "bat", "🦇"),
        ("HAT", "hat", "🎩"),
        ("PEN", "pen", "🖊️"),
        ("BOX", "box", "📦"),
        ("CUP", "cup", "☕"),
        ("BED", "bed", "🛏️"),
        ("TOY", "toy", "🧸")
    ]
    
    init() {
        loadNextWord()
    }
    
    func loadNextWord() {
        guard currentIndex < wordsWithImages.count else { return }
        let wordData = wordsWithImages[currentIndex]
        let word = wordData.0
        let imageName = wordData.1
        let emoji = wordData.2
        let missingIdx = word.count / 2
        var display = word
        display.remove(at: display.index(display.startIndex, offsetBy: missingIdx))
        display.insert("_", at: display.index(display.startIndex, offsetBy: missingIdx))
        
        var options = [Character(String(word[word.index(word.startIndex, offsetBy: missingIdx)]))]
        let wrongOptions = ["X", "Y", "Z", "Q", "W", "R"].filter { !options.contains($0) }
        options.append(contentsOf: wrongOptions.prefix(3))
        options.shuffle()
        
        currentWord = SpellingWord(word: word, display: display, 
                                   missingIndex: missingIdx, options: options,
                                   imageName: imageName, emoji: emoji)
    }
    
    func checkAnswer(_ letter: Character) {
        guard let word = currentWord else { return }
        let correct = word.word[word.word.index(word.word.startIndex, 
                                                offsetBy: word.missingIndex)]
        isCorrect = (letter == correct)
        showFeedback = true
        feedbackMessage = isCorrect ? "🎉 Correct!" : "Try Again! 💪"
        
        if isCorrect {
            score += 1
            showCongratulations = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showCongratulations = false
                self.currentIndex += 1
                self.showFeedback = false
                if self.currentIndex < self.wordsWithImages.count {
                    self.loadNextWord()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showFeedback = false
            }
        }
    }
    
    func reset() {
        currentIndex = 0
        score = 0
        showFeedback = false
        loadNextWord()
    }
}

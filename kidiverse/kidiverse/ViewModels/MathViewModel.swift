import SwiftUI
import Foundation

class MathViewModel: ObservableObject {
    struct MathQuestion {
        let num1: Int
        let num2: Int
        let operation: String
        let answer: Int
        let options: [Int]
    }
    
    @Published var currentQuestion: MathQuestion?
    @Published var score = 0
    @Published var currentIndex = 0
    @Published var showFeedback = false
    @Published var isCorrect = false
    @Published var feedbackMessage = ""
    private let totalQuestions = 10
    
    init() {
        generateQuestion()
    }
    
    func generateQuestion() {
        let num1 = Int.random(in: 1...10)
        let num2 = Int.random(in: 1...10)
        let operation = Bool.random() ? "+" : "-"
        let answer = operation == "+" ? num1 + num2 : max(num1, num2) - min(num1, num2)
        
        var options = [answer]
        while options.count < 4 {
            let wrong = answer + Int.random(in: -5...5)
            if wrong != answer && wrong >= 0 && !options.contains(wrong) {
                options.append(wrong)
            }
        }
        options.shuffle()
        
        currentQuestion = MathQuestion(num1: max(num1, num2), num2: min(num1, num2), 
                                       operation: operation, answer: answer, options: options)
    }
    
    func checkAnswer(_ selected: Int) {
        guard let question = currentQuestion else { return }
        isCorrect = (selected == question.answer)
        showFeedback = true
        feedbackMessage = isCorrect ? "🎉 Correct! +10 points" : "Try again! 💪"
        
        if isCorrect {
            score += 10
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.currentIndex += 1
                self.showFeedback = false
                if self.currentIndex < self.totalQuestions {
                    self.generateQuestion()
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
        generateQuestion()
    }
}

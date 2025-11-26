import SwiftUI
import AVFoundation

class AnimalsViewModel: ObservableObject {
    struct Animal: Identifiable {
        let id = UUID()
        let name: String
        let imageName: String
        let soundFile: String?
        let emoji: String
    }
    
    @Published var animals = [
        Animal(name: "Cat", imageName: "cat", soundFile: "meow", emoji: "🐱"),
        Animal(name: "Dog", imageName: "dog", soundFile: "bark", emoji: "🐶"),
        Animal(name: "Elephant", imageName: "elephant", soundFile: "trumpet", emoji: "🐘"),
        Animal(name: "Lion", imageName: "lion", soundFile: "roar", emoji: "🦁"),
        Animal(name: "Monkey", imageName: "monkey", soundFile: "chatter", emoji: "🐵"),
        Animal(name: "Rabbit", imageName: "rabbit", soundFile: "squeak", emoji: "🐰")
    ]
    
    @Published var selectedAnimal: Animal?
    @Published var isPlayingSound = false
    
    func selectAnimal(_ animal: Animal) {
        selectedAnimal = animal
        playSound(animal.soundFile)
    }
    
    private func playSound(_ soundName: String?) {
        // Play system sound as placeholder for animal sounds
        AudioServicesPlaySystemSound(1057) // Pop sound
        isPlayingSound = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPlayingSound = false
        }
    }
}

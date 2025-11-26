import SwiftUI
import Foundation

class DashboardViewModel: ObservableObject {
    struct DashboardCard: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let emoji: String
        let color: Color
        let route: AppRoute
    }
    
    @Published var cards: [DashboardCard] = [
        DashboardCard(title: "Learn Animals", icon: "pawprint.fill", 
                     emoji: "🦁", color: .mint, route: .learnAnimals),
        DashboardCard(title: "Spelling Fun", icon: "textformat.abc", 
                     emoji: "🔤", color: .orange, route: .spelling),
        DashboardCard(title: "Math Game", icon: "plus.forwardslash.minus", 
                     emoji: "➕", color: .purple, route: .mathGame),
        DashboardCard(title: "Bedtime Stories", icon: "book.fill", 
                     emoji: "📖", color: .blue, route: .stories),
        DashboardCard(title: "Good vs Bad", icon: "heart.fill", 
                     emoji: "⭐", color: .yellow, route: .goodVsBad)
    ]
}

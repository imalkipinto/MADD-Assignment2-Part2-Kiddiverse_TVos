import SwiftUI
import Foundation

class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        switch route {
        case .splash:
            SplashScreen()
        case .dashboard:
            DashboardView()
        case .learnAnimals:
            LearnAnimalsView()
        case .spelling:
            SpellingView()
        case .goodVsBad:
            GoodVsBadView()
        case .mathGame:
            MathGameView()
        case .stories:
            BedtimeStoriesView()
        }
    }
}

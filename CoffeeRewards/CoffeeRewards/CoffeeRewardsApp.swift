import SwiftUI

@main
struct CoffeeRewardsApp: App {
    @StateObject private var rewardsManager = RewardsManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(rewardsManager)
        }
    }
}

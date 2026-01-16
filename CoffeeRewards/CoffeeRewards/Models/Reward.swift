import Foundation

struct Reward: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let pointsRequired: Int
    let imageSystemName: String
    var isRedeemed: Bool
    let redeemedDate: Date?

    init(id: UUID = UUID(), name: String, description: String, pointsRequired: Int, imageSystemName: String, isRedeemed: Bool = false, redeemedDate: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.pointsRequired = pointsRequired
        self.imageSystemName = imageSystemName
        self.isRedeemed = isRedeemed
        self.redeemedDate = redeemedDate
    }
}

extension Reward {
    static let availableRewards = [
        Reward(name: "Free Coffee", description: "Get any size coffee free", pointsRequired: 50, imageSystemName: "cup.and.saucer.fill"),
        Reward(name: "Free Pastry", description: "Choose any pastry from our selection", pointsRequired: 30, imageSystemName: "birthday.cake.fill"),
        Reward(name: "10% Off", description: "10% off your entire purchase", pointsRequired: 20, imageSystemName: "percent"),
        Reward(name: "Free Sandwich", description: "Get any sandwich free", pointsRequired: 75, imageSystemName: "fork.knife"),
        Reward(name: "Double Points Day", description: "Earn 2x points on your next visit", pointsRequired: 40, imageSystemName: "star.fill"),
        Reward(name: "VIP Pass", description: "Skip the line for a day", pointsRequired: 100, imageSystemName: "crown.fill")
    ]
}

import Foundation
import SwiftUI

class RewardsManager: ObservableObject {
    @Published var customer: Customer
    @Published var scanHistory: [ScanHistory] = []
    @Published var redeemedRewards: [Reward] = []

    private let customerKey = "savedCustomer"
    private let historyKey = "scanHistory"
    private let rewardsKey = "redeemedRewards"

    init() {
        // Load saved data
        if let savedCustomer = UserDefaults.standard.data(forKey: customerKey),
           let decodedCustomer = try? JSONDecoder().decode(Customer.self, from: savedCustomer) {
            self.customer = decodedCustomer
        } else {
            self.customer = Customer()
        }

        if let savedHistory = UserDefaults.standard.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([ScanHistory].self, from: savedHistory) {
            self.scanHistory = decodedHistory
        }

        if let savedRewards = UserDefaults.standard.data(forKey: rewardsKey),
           let decodedRewards = try? JSONDecoder().decode([Reward].self, from: savedRewards) {
            self.redeemedRewards = decodedRewards
        }
    }

    func addPoints(_ points: Int, location: String, items: [String]) {
        customer.totalPoints += points
        customer.lifetimePoints += points
        customer.updateTier()

        let scan = ScanHistory(pointsEarned: points, location: location, itemsPurchased: items)
        scanHistory.insert(scan, at: 0)

        saveData()
    }

    func redeemReward(_ reward: Reward) -> Bool {
        guard customer.totalPoints >= reward.pointsRequired else {
            return false
        }

        customer.totalPoints -= reward.pointsRequired
        var redeemedReward = reward
        redeemedReward.isRedeemed = true
        redeemedRewards.insert(redeemedReward, at: 0)

        saveData()
        return true
    }

    func processQRCode(_ code: String) -> (success: Bool, points: Int, message: String) {
        // Parse QR code format: "COFFEE:LOCATION:POINTS:ITEMS"
        let components = code.components(separatedBy: ":")

        guard components.count >= 3,
              components[0] == "COFFEE",
              let points = Int(components[2]) else {
            return (false, 0, "Invalid QR code")
        }

        let location = components.count > 1 ? components[1] : "Coffee Shop"
        let items = components.count > 3 ? components[3].components(separatedBy: ",") : ["Coffee"]

        addPoints(points, location: location, items: items)

        return (true, points, "Successfully added \(points) points!")
    }

    private func saveData() {
        if let encoded = try? JSONEncoder().encode(customer) {
            UserDefaults.standard.set(encoded, forKey: customerKey)
        }

        if let encoded = try? JSONEncoder().encode(scanHistory) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }

        if let encoded = try? JSONEncoder().encode(redeemedRewards) {
            UserDefaults.standard.set(encoded, forKey: rewardsKey)
        }
    }

    func updateCustomerInfo(name: String, email: String) {
        customer.name = name
        customer.email = email
        saveData()
    }
}

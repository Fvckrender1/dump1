import Foundation

struct ScanHistory: Identifiable, Codable {
    let id: UUID
    let date: Date
    let pointsEarned: Int
    let location: String
    let itemsPurchased: [String]

    init(id: UUID = UUID(), date: Date = Date(), pointsEarned: Int, location: String, itemsPurchased: [String]) {
        self.id = id
        self.date = date
        self.pointsEarned = pointsEarned
        self.location = location
        self.itemsPurchased = itemsPurchased
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

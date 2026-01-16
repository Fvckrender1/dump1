import Foundation

struct Customer: Codable {
    var name: String
    var email: String
    var memberSince: Date
    var totalPoints: Int
    var lifetimePoints: Int
    var tier: MemberTier

    init(name: String = "Coffee Lover", email: String = "", memberSince: Date = Date(), totalPoints: Int = 0, lifetimePoints: Int = 0, tier: MemberTier = .bronze) {
        self.name = name
        self.email = email
        self.memberSince = memberSince
        self.totalPoints = totalPoints
        self.lifetimePoints = lifetimePoints
        self.tier = tier
    }

    enum MemberTier: String, Codable, CaseIterable {
        case bronze = "Bronze"
        case silver = "Silver"
        case gold = "Gold"
        case platinum = "Platinum"

        var requiredPoints: Int {
            switch self {
            case .bronze: return 0
            case .silver: return 100
            case .gold: return 500
            case .platinum: return 1000
            }
        }

        var color: String {
            switch self {
            case .bronze: return "brown"
            case .silver: return "gray"
            case .gold: return "yellow"
            case .platinum: return "purple"
            }
        }

        var benefits: [String] {
            switch self {
            case .bronze:
                return ["Earn 1 point per dollar", "Birthday reward"]
            case .silver:
                return ["Earn 1.5 points per dollar", "Birthday reward", "Monthly bonus points"]
            case .gold:
                return ["Earn 2 points per dollar", "Birthday reward", "Monthly bonus points", "Free drink on sign-up"]
            case .platinum:
                return ["Earn 3 points per dollar", "Birthday reward", "Monthly bonus points", "Free drink on sign-up", "VIP events access"]
            }
        }
    }

    mutating func updateTier() {
        if lifetimePoints >= MemberTier.platinum.requiredPoints {
            tier = .platinum
        } else if lifetimePoints >= MemberTier.gold.requiredPoints {
            tier = .gold
        } else if lifetimePoints >= MemberTier.silver.requiredPoints {
            tier = .silver
        } else {
            tier = .bronze
        }
    }
}

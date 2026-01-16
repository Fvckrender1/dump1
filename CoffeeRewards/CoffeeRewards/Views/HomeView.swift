import SwiftUI

struct HomeView: View {
    @EnvironmentObject var rewardsManager: RewardsManager
    @State private var selectedReward: Reward?
    @State private var showingRedeemAlert = false
    @State private var redeemMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Welcome back,")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                Text(rewardsManager.customer.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white.opacity(0.9))
                        }

                        Divider()
                            .background(Color.white.opacity(0.3))

                        HStack(spacing: 30) {
                            VStack(spacing: 4) {
                                Text("\(rewardsManager.customer.totalPoints)")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Points")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }

                            Divider()
                                .frame(height: 50)
                                .background(Color.white.opacity(0.3))

                            VStack(spacing: 4) {
                                Text(rewardsManager.customer.tier.rawValue)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Tier")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.brown, Color.brown.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                    // Progress to Next Tier
                    if let nextTier = nextTier {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Progress to \(nextTier.rawValue)")
                                .font(.headline)
                                .foregroundColor(.primary)

                            let progress = tierProgress
                            ProgressView(value: progress)
                                .tint(.brown)

                            Text("\(rewardsManager.customer.lifetimePoints) / \(nextTier.requiredPoints) lifetime points")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }

                    // Available Rewards
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Rewards")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(Reward.availableRewards) { reward in
                                    RewardCard(reward: reward, currentPoints: rewardsManager.customer.totalPoints)
                                        .onTapGesture {
                                            selectedReward = reward
                                            attemptRedeem(reward)
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Recent Activity
                    if !rewardsManager.scanHistory.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Activity")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)

                            ForEach(rewardsManager.scanHistory.prefix(3)) { scan in
                                RecentActivityRow(scan: scan)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Coffee Rewards")
            .alert("Redeem Reward", isPresented: $showingRedeemAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Redeem") {
                    if let reward = selectedReward {
                        let success = rewardsManager.redeemReward(reward)
                        redeemMessage = success ? "Reward redeemed successfully!" : "Not enough points"
                    }
                }
            } message: {
                if let reward = selectedReward {
                    Text("Redeem \(reward.name) for \(reward.pointsRequired) points?")
                }
            }
        }
    }

    private var nextTier: Customer.MemberTier? {
        let allTiers = Customer.MemberTier.allCases
        guard let currentIndex = allTiers.firstIndex(of: rewardsManager.customer.tier),
              currentIndex < allTiers.count - 1 else {
            return nil
        }
        return allTiers[currentIndex + 1]
    }

    private var tierProgress: Double {
        guard let nextTier = nextTier else { return 1.0 }
        let currentTierPoints = rewardsManager.customer.tier.requiredPoints
        let nextTierPoints = nextTier.requiredPoints
        let progress = Double(rewardsManager.customer.lifetimePoints - currentTierPoints) / Double(nextTierPoints - currentTierPoints)
        return min(max(progress, 0), 1.0)
    }

    private func attemptRedeem(_ reward: Reward) {
        if rewardsManager.customer.totalPoints >= reward.pointsRequired {
            showingRedeemAlert = true
        } else {
            redeemMessage = "You need \(reward.pointsRequired - rewardsManager.customer.totalPoints) more points"
        }
    }
}

struct RewardCard: View {
    let reward: Reward
    let currentPoints: Int

    var canRedeem: Bool {
        currentPoints >= reward.pointsRequired
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: reward.imageSystemName)
                .font(.system(size: 40))
                .foregroundColor(canRedeem ? .brown : .gray)

            VStack(spacing: 4) {
                Text(reward.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text(reward.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }

            Text("\(reward.pointsRequired) pts")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(canRedeem ? .green : .orange)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(canRedeem ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                .cornerRadius(8)
        }
        .frame(width: 160)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 3)
        .opacity(canRedeem ? 1.0 : 0.7)
    }
}

struct RecentActivityRow: View {
    let scan: ScanHistory

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)

            VStack(alignment: .leading, spacing: 4) {
                Text(scan.location)
                    .font(.headline)
                Text(scan.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("+\(scan.pointsEarned)")
                .font(.headline)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

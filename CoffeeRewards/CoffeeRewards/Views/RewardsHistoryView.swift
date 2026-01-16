import SwiftUI

struct RewardsHistoryView: View {
    @EnvironmentObject var rewardsManager: RewardsManager
    @State private var selectedSegment = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("History Type", selection: $selectedSegment) {
                    Text("Scans").tag(0)
                    Text("Redeemed").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedSegment == 0 {
                    scanHistoryView
                } else {
                    redeemedRewardsView
                }
            }
            .navigationTitle("History")
        }
    }

    private var scanHistoryView: some View {
        Group {
            if rewardsManager.scanHistory.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No scan history yet")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Text("Start scanning QR codes to earn points!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(rewardsManager.scanHistory) { scan in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(scan.location)
                                        .font(.headline)
                                    Text(scan.formattedDate)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("+\(scan.pointsEarned)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    Text("points")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            if !scan.itemsPurchased.isEmpty {
                                HStack {
                                    Image(systemName: "bag.fill")
                                        .font(.caption)
                                        .foregroundColor(.brown)
                                    Text(scan.itemsPurchased.joined(separator: ", "))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }

    private var redeemedRewardsView: some View {
        Group {
            if rewardsManager.redeemedRewards.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "gift")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No redeemed rewards yet")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Text("Earn points to redeem exciting rewards!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(rewardsManager.redeemedRewards) { reward in
                        HStack(spacing: 16) {
                            Image(systemName: reward.imageSystemName)
                                .font(.system(size: 30))
                                .foregroundColor(.brown)
                                .frame(width: 50, height: 50)
                                .background(Color.brown.opacity(0.1))
                                .cornerRadius(10)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(reward.name)
                                    .font(.headline)
                                Text(reward.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(reward.pointsRequired)")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                Text("pts used")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }
}

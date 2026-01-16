import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var rewardsManager: RewardsManager
    @State private var isEditing = false
    @State private var editedName: String = ""
    @State private var editedEmail: String = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.brown)

                            Text(rewardsManager.customer.name)
                                .font(.title2)
                                .fontWeight(.bold)

                            HStack(spacing: 4) {
                                Image(systemName: tierIcon)
                                    .foregroundColor(tierColor)
                                Text(rewardsManager.customer.tier.rawValue)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(tierColor.opacity(0.2))
                            .cornerRadius(20)
                        }
                        .padding(.vertical)
                        Spacer()
                    }
                }

                Section(header: Text("Account Information")) {
                    if isEditing {
                        TextField("Name", text: $editedName)
                        TextField("Email", text: $editedEmail)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    } else {
                        HStack {
                            Text("Name")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(rewardsManager.customer.name)
                        }

                        HStack {
                            Text("Email")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(rewardsManager.customer.email.isEmpty ? "Not set" : rewardsManager.customer.email)
                                .foregroundColor(rewardsManager.customer.email.isEmpty ? .secondary : .primary)
                        }
                    }

                    HStack {
                        Text("Member Since")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formattedMemberSince)
                    }
                }

                Section(header: Text("Points Summary")) {
                    HStack {
                        Label("Current Points", systemImage: "star.fill")
                        Spacer()
                        Text("\(rewardsManager.customer.totalPoints)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }

                    HStack {
                        Label("Lifetime Points", systemImage: "chart.line.uptrend.xyaxis")
                        Spacer()
                        Text("\(rewardsManager.customer.lifetimePoints)")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }

                    HStack {
                        Label("Total Scans", systemImage: "qrcode")
                        Spacer()
                        Text("\(rewardsManager.scanHistory.count)")
                            .fontWeight(.bold)
                    }

                    HStack {
                        Label("Rewards Redeemed", systemImage: "gift.fill")
                        Spacer()
                        Text("\(rewardsManager.redeemedRewards.count)")
                            .fontWeight(.bold)
                    }
                }

                Section(header: Text("Tier Benefits")) {
                    ForEach(rewardsManager.customer.tier.benefits, id: \.self) { benefit in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(benefit)
                                .font(.subheadline)
                        }
                    }
                }

                Section(header: Text("Next Tier")) {
                    if let nextTier = nextTier {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(nextTier.rawValue)
                                    .font(.headline)
                                Spacer()
                                Text("\(rewardsManager.customer.lifetimePoints) / \(nextTier.requiredPoints)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            ProgressView(value: tierProgress)
                                .tint(.brown)

                            Text("Benefits:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)

                            ForEach(nextTier.benefits, id: \.self) { benefit in
                                HStack {
                                    Image(systemName: "star.fill")
                                        .font(.caption)
                                        .foregroundColor(.brown.opacity(0.6))
                                    Text(benefit)
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    } else {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.purple)
                            Text("You've reached the highest tier!")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            saveChanges()
                        } else {
                            startEditing()
                        }
                    }
                }

                if isEditing {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            cancelEditing()
                        }
                    }
                }
            }
        }
    }

    private var tierIcon: String {
        switch rewardsManager.customer.tier {
        case .bronze: return "seal.fill"
        case .silver: return "shield.fill"
        case .gold: return "star.fill"
        case .platinum: return "crown.fill"
        }
    }

    private var tierColor: Color {
        switch rewardsManager.customer.tier {
        case .bronze: return .brown
        case .silver: return .gray
        case .gold: return .yellow
        case .platinum: return .purple
        }
    }

    private var formattedMemberSince: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: rewardsManager.customer.memberSince)
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

    private func startEditing() {
        editedName = rewardsManager.customer.name
        editedEmail = rewardsManager.customer.email
        isEditing = true
    }

    private func saveChanges() {
        rewardsManager.updateCustomerInfo(name: editedName, email: editedEmail)
        isEditing = false
    }

    private func cancelEditing() {
        isEditing = false
        editedName = ""
        editedEmail = ""
    }
}

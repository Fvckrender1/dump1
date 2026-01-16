# Coffee Rewards iOS App

A complete iOS rewards app for coffee shops that allows customers to scan QR codes and earn rewards points.

## Features

### 1. QR Code Scanner
- Real-time QR code scanning using device camera
- Instant points processing
- Visual feedback with scanning frame overlay
- Automatic vibration on successful scan

### 2. Rewards Dashboard
- View current points balance
- Display member tier (Bronze, Silver, Gold, Platinum)
- Progress tracker to next tier
- Available rewards catalog
- Recent activity history

### 3. Rewards System
- **Available Rewards:**
  - Free Coffee (50 points)
  - Free Pastry (30 points)
  - 10% Off (20 points)
  - Free Sandwich (75 points)
  - Double Points Day (40 points)
  - VIP Pass (100 points)

### 4. Member Tiers
- **Bronze** (0+ lifetime points): 1 point per dollar, birthday reward
- **Silver** (100+ lifetime points): 1.5 points per dollar, birthday reward, monthly bonus
- **Gold** (500+ lifetime points): 2 points per dollar, all Silver benefits, free drink on sign-up
- **Platinum** (1000+ lifetime points): 3 points per dollar, all Gold benefits, VIP events access

### 5. History Tracking
- View all scan history with dates and locations
- Track redeemed rewards
- Points earned per transaction
- Items purchased details

### 6. User Profile
- Edit name and email
- View membership start date
- Points summary (current + lifetime)
- Tier benefits display
- Progress to next tier

## QR Code Format

The app expects QR codes in the following format:

```
COFFEE:LOCATION:POINTS:ITEMS
```

**Examples:**
```
COFFEE:Downtown Branch:10:Latte,Croissant
COFFEE:Main Street:15:Cappuccino,Sandwich,Cookie
COFFEE:Airport Location:20:Americano
```

**Format Breakdown:**
- `COFFEE`: Required prefix identifier
- `LOCATION`: Store location name
- `POINTS`: Number of points to award
- `ITEMS`: Comma-separated list of purchased items (optional)

## Technical Details

### Technologies Used
- SwiftUI for UI
- AVFoundation for QR code scanning
- UserDefaults for data persistence
- MVVM architecture

### Requirements
- iOS 15.0+
- Xcode 15.0+
- Swift 5.0+
- Camera access permission

### Project Structure
```
CoffeeRewards/
├── CoffeeRewards/
│   ├── Models/
│   │   ├── Customer.swift
│   │   ├── Reward.swift
│   │   └── ScanHistory.swift
│   ├── Views/
│   │   ├── HomeView.swift
│   │   ├── ScannerView.swift
│   │   ├── RewardsHistoryView.swift
│   │   └── ProfileView.swift
│   ├── ViewModels/
│   │   └── RewardsManager.swift
│   ├── Utils/
│   │   └── QRCodeScanner.swift
│   ├── CoffeeRewardsApp.swift
│   ├── ContentView.swift
│   └── Info.plist
└── CoffeeRewards.xcodeproj/
```

## Installation

1. Open `CoffeeRewards.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run (⌘R)
4. Grant camera permissions when prompted

## Usage

1. **Scan QR Code**: Tap the "Scan" tab and point camera at receipt QR code
2. **View Points**: Check your points balance on the Home tab
3. **Redeem Rewards**: Tap on any available reward to redeem with your points
4. **View History**: Check scan history and redeemed rewards in History tab
5. **Edit Profile**: Update your information in Profile tab

## Data Persistence

All user data is stored locally using UserDefaults:
- Customer information (name, email, points, tier)
- Scan history
- Redeemed rewards

## Future Enhancements

- Backend API integration
- Push notifications for special offers
- Social sharing features
- Location-based rewards
- Gift card integration
- Referral program

## License

Copyright © 2026 Coffee Rewards. All rights reserved.

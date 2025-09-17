# Sales Bets - Flutter App

A comprehensive Flutter application for business betting with a "win but never lose" concept, built with Clean Architecture principles and modern Flutter practices.

## 🎯 App Concept

**Sales Bets** is a unique betting platform where users can bet on business challenges and team performance without the risk of losing their stake. The app implements a "no-loss" betting system where:

- Users stake credits on business outcomes
- If they win, they gain additional credits
- If they lose, they keep their original stake (no-loss guarantee)
- Focus on business challenges, team performance, and sales targets

## 🏗️ Architecture Overview

This project follows Clean Architecture principles with Provider state management:

```
lib/
├── core/                           # Core functionality shared across features
│   ├── config/                     # Firebase and app configuration
│   ├── constants/                  # App constants and configuration
│   ├── di/                        # Dependency injection setup
│   ├── errors/                    # Error handling (failures & exceptions)
│   ├── services/                  # Core services (Firebase, notifications)
│   ├── theme/                     # App theming and UI components
│   └── utils/                     # Utility functions
├── features/                      # Feature-based modules
│   ├── auth/                      # Authentication (Firebase Auth)
│   ├── betting/                   # Betting system and wallet
│   ├── home/                      # Home dashboard
│   ├── leaderboard/               # User rankings and stats
│   ├── live_streams/              # Live streaming and chat
│   ├── main/                      # Main navigation
│   ├── notifications/             # Push notifications
│   ├── onboarding/                # User onboarding flow
│   ├── profile/                   # User profile and settings
│   └── teams/                     # Teams and athletes management
└── shared/                        # Shared components across features
```

## 🚀 Key Features

### 🔐 Authentication
- **Firebase Authentication** with email/password
- **User registration** and login
- **Session management** with automatic auth state handling
- **Password reset** functionality
- **User profile** management

### 💰 Betting System
- **No-loss betting** - users never lose their stake
- **Credit-based system** with virtual currency
- **Real-time betting** on business challenges
- **Wallet management** with transaction history
- **Win celebrations** with animations and rewards
- **Demo betting** for testing purposes

### 🏠 Home Dashboard
- **Active challenges** display
- **Trending teams** and athletes
- **Leaderboard** with top performers
- **Wallet overview** with credit balance
- **Quick betting** interface
- **Notification center**

### 👥 Teams & Athletes
- **Team profiles** with performance stats
- **Follow/unfollow** functionality
- **Search and filter** teams by category
- **Trending teams** based on popularity
- **Performance metrics** and win rates
- **Recent activities** tracking

### 📊 Leaderboard
- **User rankings** by earnings
- **Win rate statistics**
- **Achievement badges**
- **Full leaderboard** view with pagination
- **Current user** position tracking

### 📱 Live Streaming
- **Video streaming** integration
- **Real-time chat** during streams
- **Stream management** and scheduling
- **Interactive features** during live events

### 🔔 Notifications
- **Push notifications** via Firebase Cloud Messaging
- **Local notifications** for app events
- **Notification history** and management
- **Real-time updates** for betting results

### 🎨 UI/UX Features
- **Dark/Light theme** support
- **Smooth animations** and transitions
- **Responsive design** for different screen sizes
- **Modern Material Design** components
- **Custom widgets** and reusable components

## 📦 Dependencies

### Core Dependencies
- **`provider`**: State management
- **`firebase_core`**: Firebase integration
- **`firebase_auth`**: Authentication
- **`cloud_firestore`**: Database
- **`firebase_messaging`**: Push notifications
- **`shared_preferences`**: Local storage
- **`get_it`**: Dependency injection

### UI & Animation
- **`confetti`**: Win celebration animations
- **`lottie`**: Advanced animations
- **`video_player`**: Live streaming
- **`flutter_local_notifications`**: Local notifications

### Development
- **`flutter_lints`**: Code quality
- **`build_runner`**: Code generation
- **`json_serializable`**: JSON serialization

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd sales_bets
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication, Firestore, and Cloud Messaging
3. Download `google-services.json` and place in `android/app/`
4. Update `lib/core/config/firebase_options.dart` with your project configuration

### 4. Generate Code
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the App
```bash
flutter run
```

## 🏛️ Architecture Details

### State Management
- **Provider Pattern** for state management
- **ChangeNotifier** for reactive updates
- **Consumer widgets** for UI updates
- **Centralized state** management per feature

### Data Flow
1. **UI** triggers user action
2. **Provider** handles state changes
3. **Service** executes business logic
4. **Firebase** stores/retrieves data
5. **Provider** updates state
6. **UI** rebuilds with new data

### Firebase Integration
- **Authentication**: User login/registration
- **Firestore**: Real-time data storage
- **Cloud Messaging**: Push notifications
- **Real-time listeners**: Live data updates

## 🎮 User Journey

### 1. Onboarding
- Welcome screens explaining the "no-loss" concept
- Feature introduction and benefits
- Theme selection (light/dark mode)

### 2. Authentication
- User registration with email/password
- Login with existing credentials
- Password reset if needed

### 3. Home Experience
- View active business challenges
- Check wallet balance and recent activity
- Browse trending teams and leaderboard
- Place demo bets to understand the system

### 4. Betting Process
- Select a business challenge
- Choose a team or outcome
- Set stake amount (credits)
- Confirm bet placement
- Wait for results with real-time updates

### 5. Team Management
- Search and discover teams
- Follow favorite teams and athletes
- View team performance and statistics
- Get notifications about followed teams

## 🔧 Development Guidelines

### Adding New Features
1. Create feature directory: `lib/features/your_feature/`
2. Set up the structure:
   - `domain/entities/` - Business entities
   - `presentation/providers/` - State management
   - `presentation/pages/` - UI screens
   - `presentation/widgets/` - Reusable components
3. Register providers in `main.dart`
4. Add navigation and routing

### Code Organization
- **Feature-based** structure
- **Separation of concerns** between layers
- **Reusable components** across features
- **Consistent naming** conventions
- **Comprehensive error handling**

### Testing Strategy
- **Unit tests** for business logic
- **Widget tests** for UI components
- **Integration tests** for user flows
- **Provider tests** for state management

## 🚧 Current Status

### ✅ Completed Features
- [x] Firebase Authentication integration
- [x] No-loss betting system
- [x] Team search and filtering
- [x] Leaderboard with rankings
- [x] Wallet management
- [x] Betting history
- [x] Notification system
- [x] Theme switching
- [x] Onboarding flow
- [x] Live streaming UI
- [x] Profile management

### 🔄 In Progress
- [ ] Real-time betting updates
- [ ] Advanced analytics
- [ ] Social features
- [ ] Payment integration (if needed)

### 📋 Future Enhancements
- [ ] Push notification scheduling
- [ ] Advanced team statistics
- [ ] Tournament system
- [ ] Social sharing features
- [ ] Advanced filtering options
- [ ] Offline support
- [ ] Performance optimizations

## 🎯 Business Logic

### No-Loss Betting System
- Users stake credits on business outcomes
- Winning bets return stake + winnings
- Losing bets return the original stake (no loss)
- System encourages participation without risk

### Credit System
- Virtual currency for betting
- No real money involved
- Credits earned through successful bets
- Can be used for all betting activities

### Challenge Types
- Sales targets and quotas
- Team performance metrics
- Project completion goals
- Customer satisfaction scores
- Revenue targets

## 📱 Screenshots

*Add screenshots of key features here*

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review the code comments

---

**Sales Bets** - Where business meets betting, and you can win without losing! 🎯
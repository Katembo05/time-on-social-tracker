# Social Media Tracker

A Flutter app that helps users track and limit their social media usage. The app provides real-time monitoring of social media app usage, sends notifications every 5 minutes about cumulative usage, and automatically blocks apps after reaching a 40-minute daily limit.

## Features

- Real-time tracking of social media app usage
- Beautiful Material Design UI with Inter font
- Usage statistics with circular progress indicator
- Daily and weekly usage history with charts
- Automatic app blocking after 40 minutes of daily usage
- 5-minute interval notifications about usage
- Dark mode support

## Getting Started

### Prerequisites

- Flutter SDK (>=2.19.0)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator (API level 21 or higher)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/social-media-tracker.git
cd social-media-tracker
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Project Structure

```
lib/
  ├── main.dart                 # App entry point
  ├── models/                   # Data models
  │   └── app_usage_model.dart
  ├── providers/               # State management
  │   └── usage_provider.dart
  ├── services/               # Business logic
  │   └── usage_service.dart
  ├── screens/                # UI screens
  │   ├── app_shell.dart
  │   ├── dashboard_screen.dart
  │   ├── history_screen.dart
  │   ├── settings_screen.dart
  │   └── block_screen.dart
  ├── utils/                  # Utilities
  │   └── theme_config.dart
  └── widgets/                # Reusable widgets
      ├── usage_circle.dart
      └── app_usage_card.dart
```

## Implementation Details

- Uses Provider for state management
- Implements Material Design 3 with custom theme
- Uses Google Fonts for typography (Inter font)
- Implements custom painters for circular progress
- Uses platform channels for app usage tracking (mock data for demo)
- Uses local notifications for usage alerts
- Implements app blocking through accessibility services

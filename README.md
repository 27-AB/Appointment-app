# ASTU Direct Appointment — Flutter App

A mobile appointment booking system for Adama Science and Technology University (ASTU).

## Team Members & File Ownership

| Member | File(s) | Responsibility |
|--------|---------|---------------|
| Member 1 | `lib/models/models.dart`, `lib/main.dart` | Data models, app entry point |
| Member 2 | `lib/providers/app_state_provider.dart` | State management, business logic |
| Member 3 | `lib/screens/login_screen.dart`, `lib/screens/register_screen.dart` | Authentication screens |
| Member 4 | `lib/screens/home_screen.dart` | Home, calendar, alerts, control desk tabs |
| Member 5 | `lib/screens/booking_screen.dart`, `lib/widgets/ai_chat_widget.dart` | Booking flow, AI assistant |

## Project Structure

```
lib/
├── main.dart                        # App entry & routing
├── models/
│   └── models.dart                  # Data models & enums
├── providers/
│   └── app_state_provider.dart      # State management
├── screens/
│   ├── login_screen.dart            # Login UI
│   ├── register_screen.dart         # Registration UI
│   ├── home_screen.dart             # Main tabs (Board, Alerts, Planner, Control)
│   └── booking_screen.dart          # Appointment booking wizard
└── widgets/
    └── ai_chat_widget.dart          # AI chatbot widget
```

## How to Run

```bash
flutter pub get
flutter run
```

## Features

- Book appointments with ASTU officials
- Date, time, and duration selection
- Priority levels (Low / Medium / High)
- Secretary control desk for approvals
- In-app AI assistant (offline, no API key needed)
- Notification system

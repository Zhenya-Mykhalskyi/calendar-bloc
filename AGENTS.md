# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

Flutter calendar/event management application (`keym_calendar`). Single-package app using BLoC pattern, SQLite via `sqflite`, and `table_calendar`. No backend services or external APIs required.

### Flutter SDK

This project requires **Flutter 3.24.x** (Dart 3.5.x). The latest Flutter stable (3.41+) is **not** compatible due to breaking changes in transitive dependencies (`web`, `win32`, `image_picker_platform_interface`). The SDK is installed at `/opt/flutter`.

### Key commands

| Task | Command |
|------|---------|
| Install deps | `flutter pub get` |
| Lint/analyze | `flutter analyze` |
| Run tests | `flutter test` |
| Build web | `flutter build web` |
| Run web dev server | `flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0` |
| Run in Chrome | `flutter run -d chrome` |

### Known limitations

- **Web platform**: The app uses `sqflite` for data persistence, which does not support the web platform. The app UI loads and renders correctly on web, but database operations (loading/saving events) will hang or fail silently. For full end-to-end testing with data persistence, use a mobile emulator or Linux desktop target (`flutter run -d linux`).
- **Linux desktop build**: Requires `libgtk-3-dev`, `ninja-build`, `libsqlite3-dev`, and `libstdc++-13-dev` system packages plus a symlink: `sudo ln -sf /usr/lib/gcc/x86_64-linux-gnu/13/libstdc++.so /usr/lib/x86_64-linux-gnu/libstdc++.so`.
- `flutter analyze` exits with code 1 for info-level deprecation warnings (`MaterialStateProperty` → `WidgetStateProperty`); these are non-blocking.

### Architecture

- **BLoC pattern**: `CalendarBloc` (global events CRUD) and `DayEventsBloc` (day-specific view). Both provided via `MultiBlocProvider` in `main.dart`.
- **Repository pattern**: `CalendarRepository` abstracts SQLite access; `FakeCalendarRepository` is used in tests.
- **Feature folders**: `lib/features/{calendar,day_events,add_event}/` each with `view/`, `widgets/`, `bloc/` subdirectories.

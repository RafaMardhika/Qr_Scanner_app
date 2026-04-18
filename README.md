# 📱 QR Scanner App — Flutter

A mobile application built with Flutter that scans QR codes using the device camera and validates them through the Laravel REST API developed in Part 1.

---

## 📋 App Overview

This app is **Part 2** of the QR Scanner project. It consumes the existing Laravel API to:
- Authenticate users (login/logout)
- Display list of QR codes
- Scan QR codes using the device camera
- Send scanned data to the API for validation
- Display proper responses (valid / invalid / already used)
- Handle loading states and API errors gracefully

---

## 🔗 API Integration

This app connects to the **Laravel QR Scanner API** (Part 1):
- **Base URL:** `http://10.0.2.2:8000/api` (emulator) or your server IP
- **Authentication:** Laravel Sanctum (Bearer Token)
- **Token storage:** Shared Preferences (persistent login)

### Endpoints Used:
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/auth/login` | POST | Login and get token |
| `/api/auth/logout` | POST | Logout and revoke token |
| `/api/qr-codes` | GET | Get list of QR codes |
| `/api/qr-codes/scan` | POST | Validate scanned QR code |

### How API Integration Works:
1. User logs in → API returns Bearer token
2. Token saved to device via Shared Preferences
3. All subsequent requests use `Authorization: Bearer {token}` header
4. QR scan result sends content to API → API returns valid/invalid/already used
5. App displays appropriate response to user

---

## 🚀 How to Run Locally

### Requirements
- Flutter SDK >= 3.10
- Android Studio or VS Code
- Android Emulator or physical Android device
- Laravel API (Part 1) running locally

### Installation Steps

```bash
# 1. Clone the repository
git clone https://github.com/RafaMardhika/Qr_Scanner_app.git
cd Qr_Scanner_app

# 2. Install dependencies
flutter pub get

# 3. Make sure Laravel API is running
# Open separate terminal and run:
# php artisan serve

# 4. Run the app
flutter run
```

### Build APK
```bash
# Debug APK
flutter build apk --debug

# Release APK (arm64)
flutter build apk --release --target-platform android-arm64
```

APK location: `build/app/outputs/flutter-apk/`

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point & auth wrapper
├── models/
│   └── qr_model.dart        # QR code data model
├── services/
│   └── api_service.dart     # HTTP requests & token management
├── screens/
│   ├── login_screen.dart    # Login UI
│   ├── home_screen.dart     # QR code list UI
│   └── scanner_screen.dart  # QR camera scanner UI
└── widgets/                 # Reusable UI components
```

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **HTTP Client:** `http` package
- **QR Scanner:** `mobile_scanner`
- **Local Storage:** `shared_preferences`
- **State Management:** `setState` + `provider`
- **API:** Laravel 10 REST API with Sanctum

---

## ✨ Features

- Token-based authentication with persistent login
- QR code scanning using device camera
- Real-time API validation with loading indicator
- Proper error handling for network issues
- Clean separation of UI, service, and model layers
- No hardcoded responses — all data comes from API

---

## 🔗 Related Repository

**Part 1 — Laravel API:** [https://github.com/RafaMardhika/laravel-qr-api](https://github.com/RafaMardhika/laravel-qr-api)

---

## 👤 Author

**Rafa Mardhika**
GitHub: [@RafaMardhika](https://github.com/RafaMardhika)

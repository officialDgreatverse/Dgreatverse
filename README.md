# DgreatVerse

**Connect, share, and thrive.** Chat, share moments, and stay connected with your community.

DgreatVerse is a social networking web app (PWA) with real-time chat and push notifications, built to work seamlessly on both the web and as a native Android app.

## Features

- 💬 Real-time chat and messaging
- 🔔 Push notifications (web push + native FCM on Android)
- 📱 Installable as a Progressive Web App
- 🎨 Custom-branded UI with smooth animations
- 🔗 Deep linking support

## Tech Stack

- **Frontend:** HTML, CSS, JavaScript (single-page app)
- **Backend:** [Supabase](https://supabase.com) (auth, database, storage)
- **Notifications:** Web Push API + Firebase Cloud Messaging (via Capacitor)
- **Native wrapper:** [Capacitor](https://capacitorjs.com) for Android APK builds

## Getting Started

1. Clone the repo
2. Open `index.html` in a browser, or serve it with any static file server
3. Configure your Supabase project URL and keys
4. For the Android build, install `@capacitor/push-notifications` and run `cap sync`

## License

© 2026 Nyenwe Greatman. All rights reserved.
This source code is the original work of Nyenwe Greatman ([TikTok: @officialdgreatverse](https://www.tiktok.com/@officialdgreatverse) | dgreatnation83@gmail.com). Unauthorized copying, redistribution, or reposting of this code — or substantial portions of it — under a different name or claimed authorship is not permitted.

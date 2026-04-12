# Farm Fresh Marketplace

A comprehensive farm-to-table marketplace mobile app built with Flutter, featuring AI-powered dashboards and intelligent agent assistants.

## Features

- **Customer Shopping** — Browse local farm products, AI recommendations, cart, checkout, and order history
- **Driver Delivery Portal** — Earnings dashboard, route optimization, delivery management with AI insights
- **Farmer/Merchant Portal** — Revenue analytics, AI crop advisor, product management, demand forecasting
- **Real-time Order Tracking** — Live order status updates with timeline visualization
- **AI Agent Hub** — 6 specialist AI agents (Growth, Supply Chain, Support, Nutrition, Pricing, Sustainability)
- **Professional Dashboards** — Interactive charts (line, bar, pie, sparkline) with real-time metrics

## Getting Started

```bash
flutter pub get
flutter run
```

## Download APK

Go to the **Actions** tab and download the latest `farm-fresh-release` artifact, or check **Releases** for published APKs.

## Project Structure

```
lib/
├── main.dart                 # App entry point & role selection
├── models/                   # Data models (product, order, cart, agents)
├── providers/                # State management (Provider)
├── screens/
│   ├── customer/             # Customer shopping screens
│   ├── driver/               # Driver delivery screens
│   ├── farmer/               # Farmer/merchant screens
│   └── agents/               # AI Agent Hub & chat
├── services/                 # AI service engine
├── widgets/                  # Dashboard charts & reusable widgets
└── utils/                    # Utilities and constants
```

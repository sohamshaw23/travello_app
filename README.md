# TRAVELLO


<img width="1983" height="793" alt="tbanner" src="https://github.com/user-attachments/assets/3f72990b-aecf-4a8a-b068-7784d0c65a51" />






<p align="center">
  Discovery. Intelligent routing. Trip progression. Profile-driven travel storytelling.
</p>

---

## Intro

Travello is a visually distinctive iOS travel app paired with a modular FastAPI backend. It is designed as a polished product demo rather than a simple prototype, combining a custom pixel-inspired interface with a typed networking layer and an extensible backend for route intelligence.

The project blends two goals:

- a memorable front-end experience with strong visual identity
- a backend architecture that is clean enough to scale into a more realistic demo or MVP

## Highlights

- Native SwiftUI app with a custom retro-futurist design language
- FastAPI backend with clean `routes / models / services` separation
- Typed `URLSession` client for integrating backend responses into the app
- Intelligent transport endpoint with pricing, route optimization, caching, and reasoning
- Light and dark mode support
- Multi-screen flow covering discovery, transport, trips, booking, and profile

## Product Surface

Travello currently includes five major experiences:

### `Home / Discovery`

- Trending destinations
- Travel cards with curated presentation
- Branded landing experience inside the app shell

### `Transport Finder`

- Multi-option route comparison
- Cheapest, fastest, and balanced route generation
- Segment-level pricing breakdown
- Lightweight reasoning on cost and time trade-offs

### `Trip Details`

- Mission-style trip narrative
- Duration, difficulty, and reward framing
- Required items and travel preparation view

### `Booking / Ticket`

- Boarding-pass inspired booking interface
- Ticket summary and reward framing

### `User Profile`

- Rank and level progression
- Travel badges
- Previous trip archive
- User stats and progress tracking

## Visual Direction

The interface is intentionally not generic. It uses:

- uppercase pixel-leaning typography
- gradient-accented navigation headers
- framed cards and hard-edged panels
- soft futuristic travel colors
- game-inspired progress presentation

The result sits somewhere between a travel app, an interactive dashboard, and a stylized quest log.

## Stack

### Frontend

- Swift
- SwiftUI
- `NavigationStack`
- `TabView`
- `URLSession`

### Backend

- FastAPI
- Pydantic
- Async service functions
- `httpx` for async external requests

## Repository Layout

```text
travelo/
├── main.py
├── requirements.txt
├── models/
├── routes/
├── services/
├── README.md
└── travelo/
    ├── APIClient.swift
    ├── ContentView.swift
    ├── HomeView.swift
    ├── TransportView.swift
    ├── TripView.swift
    ├── ProfileView.swift
    ├── PixelTheme.swift
    └── traveloApp.swift
```

## Architecture

### iOS App

The SwiftUI app is split into focused screens with a shared visual system:

- [ContentView.swift](/Users/sohamshaw/Desktop/travelo/travelo/ContentView.swift:1) for tab navigation
- [PixelTheme.swift](/Users/sohamshaw/Desktop/travelo/travelo/PixelTheme.swift:1) for palette, card styling, custom headers, and scrolling behavior
- [APIClient.swift](/Users/sohamshaw/Desktop/travelo/travelo/APIClient.swift:1) for typed networking

### Backend

The backend follows a clean modular structure:

- `routes/` defines API boundaries
- `models/` defines Pydantic request and response contracts
- `services/` contains pricing, routing, reasoning, caching, and data orchestration

This keeps API design, business logic, and integration concerns separated cleanly.

## API Surface

Base URL:

```text
http://localhost:8000
```

Available endpoints:

- `GET /destinations`
- `POST /get-cheapest-route`
- `GET /trip/{trip_id}`
- `POST /book-trip`
- `GET /profile/{user_id}`

Interactive docs:

```text
http://localhost:8000/docs
```

## Intelligent Transport Layer

The transport system is the most advanced part of the backend and is designed to feel closer to a real product demo.

It currently supports:

- multiple route options
- segment-level route modeling
- dynamic pricing by transport mode and distance
- city-sensitive pricing multipliers
- route explanations for user-facing reasoning
- caching for repeated route lookups
- optional Google Maps integration through `GOOGLE_MAPS_API_KEY`

Route options are generated for:

- cheapest
- fastest
- balanced

Each result includes:

- total cost
- total time
- distance
- route segments
- route path coordinates
- explanation string

## Quick Start

### 1. Run the backend

Install dependencies:

```bash
pip install -r requirements.txt
```

Start the API server:

```bash
uvicorn main:app --reload
```

### 2. Run the iOS app

1. Open the project in Xcode
2. Select the `travelo` scheme
3. Build and run on a simulator or device

### 3. Connect the app to the API

The app already includes a typed Swift networking layer in [APIClient.swift](/Users/sohamshaw/Desktop/travelo/travelo/APIClient.swift:1).

Current fetch methods:

- `fetchDestinations()`
- `fetchRoutes(source:destination:)`
- `fetchProfile(userID:)`
- `fetchTripDetails(tripID:)`

If you run the app on a physical device, replace `localhost` with your machine’s LAN IP in the API client.

## Screenshots

This repository is well-suited for a richer README with app previews. You can place exported screenshots in a folder such as:

```text
docs/screenshots/
```

Suggested sections:

- Home / Discovery
- Transport Finder
- Trip Details
- Booking / Ticket
- User Profile
- Dark Mode

## Why This Project Works Well

Travello is appealing because it has both presentation value and structural substance.

- It looks intentional rather than boilerplate
- It spans both client and server concerns
- It uses typed API boundaries
- It has a strong demo narrative for portfolio or showcase use
- It already contains the beginnings of route intelligence instead of a purely static mock

## Good Next Steps

- Bind live API data into every SwiftUI screen
- Add remote image loading for destination cards
- Add persistence for saved trips and bookings
- Add authentication and per-user backend state
- Improve transport results with real provider data and city-specific tuning
- Add automated tests for transport pricing and reasoning services

## Local Configuration

Optional live routing support:

```bash
export GOOGLE_MAPS_API_KEY="your_api_key_here"
```

Without this key, the backend falls back to a deterministic route generation strategy so the demo still runs locally.

## Repository

GitHub:

```text
https://github.com/sohamshaw23/travello_app.git
```

## Author

Soham Shaw

---

Travello is a strong base for a polished student project, a portfolio case study, a hackathon submission, or a startup-style MVP demo.

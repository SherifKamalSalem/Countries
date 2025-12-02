# Countries

A SwiftUI app for saving and exploring country information. Search for countries, see their capital and currency, and keep up to 5 favorites.

![App Demo](https://github.com/user-attachments/assets/030649df-e2cb-474c-b68e-b257f255bd14)

## How to Run

1. Open `Countries.xcodeproj` in Xcode 16+
2. Wait for packages to resolve
3. Run on simulator or device

For location features to work properly, you'll need to either use a physical device or enable location simulation in the simulator.

## Architecture

I split the app into SPM packages — one per feature, plus shared infrastructure (`Core`, `Networking`, `Storage`, etc.). This keeps compile times reasonable and forces me to think about dependencies.

The main packages:
- **Core** — Models and shared protocols
- **CountriesListFeature** — Main screen with saved countries
- **CountryDetailsFeature** — Detail screen showing capital/currency
- **Navigation** — Coordinator and a simple DI container

Each feature follows a basic Clean Architecture pattern: Use Cases → Repository → Network/Storage. Nothing fancy, just enough structure to keep things testable.

## Some Decisions I Made

### Storage: File-based JSON instead of Core Data

The requirements mentioned local storage. I went with writing JSON to the documents directory instead of Core Data or UserDefaults.

Why not UserDefaults? It's meant for preferences, not data. It also loads synchronously at app launch, which isn't great if you're storing anything substantial.

Why not Core Data? For 5 countries, it felt like overkill. Setting up the stack, dealing with managed object contexts, writing migrations — none of that complexity pays off here.

A simple `Codable` file works fine. It's async, easy to test, and I can swap it out later if needed.

### Navigation: Coordinator with NavigationPath

I used SwiftUI's `NavigationPath` with a typed `AppRoute` enum. The `AppCoordinator` owns the navigation state and the features just call `router.navigate(to: .countryDetail(country))`.

This keeps the views dumb and makes it easier to test navigation logic.

### Tests: Swift Testing framework

I used the new Swift Testing framework instead of XCTest. Mostly because I wanted to try it out, but also because `@Test("description")` and `#expect()` read better than `XCTAssertEqual`.

## What I'd Improve

A few things I cut corners on:

- **Error handling** — Most errors just show an alert. In a real app I'd add retry logic and better error messages.
- **No offline search** — Saved countries work offline, but search always hits the network.
- **Strings are hardcoded** — Should be in a Localizable.strings file.
- **No UI tests** — Focused on unit testing the business logic. Would add UI tests for the main flows given more time.

## Requirements Coverage

| Feature | Done |
|---------|------|
| Search countries | ✓ |
| Show capital + currency | ✓ |
| Add up to 5 countries | ✓ |
| Detail view on tap | ✓ |
| Auto-add from GPS | ✓ |
| Default country if location denied | ✓ (Egypt) |
| Remove countries | ✓ |
| Offline storage | ✓ |
| Unit tests | ✓ |

## API

Uses [REST Countries API](https://restcountries.com) v2.

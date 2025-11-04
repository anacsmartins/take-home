# URL Shortener – Flutter Take Home

Flutter mobile application to shorten URLs and display the list of recently generated short links.

## Objective

- Text input to type a URL
- Button to request URL shortening
- List displaying all returned aliases
- Session-based in-memory state (no local persistence)

# URL Shortener – Flutter Take Home

[![tests](https://github.com/your_user/your_repo_name/actions/workflows/flutter_test.yml/badge.svg)](https://github.com/your_user/your_repo_name/actions/workflows/flutter_test.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
![Flutter](https://img.shields.io/badge/Flutter-Enterprise_Architecture-blue)

Mobile application built in Flutter to shorten URLs and display the recently generated short links during the session.  
Focused on code quality, separation of concerns and testability.

### API
`https://url-shortener-server.onrender.com/api/alias`
The backend logic and URL shortening service is provided externally (this app only consumes the exposed API).

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Architecture | Clean Architecture |
| Mobile | Flutter (Dart Null Safety) |
| State Management | Cubit (flutter_bloc 8.x) |
| DI | get_it + injectable (+ generator) |
| HTTP Client | http |
| Tests | flutter_test + mocktail |
| Quality | clean code, sealed state, domain isolation, zero smell |

---

## Project Structure
```bash
lib/
data/
domain/
presentation/
shared/
injection/
test/
domain/
data/
presentation/
``` 

---

## Running

```bash
flutter pub get
flutter run

Running Tests

flutter test

```

## Project Architecture

This application follows **Clean Architecture**, a widely adopted approach in Flutter that enforces clear separation of concerns, improves testability, predictability and keeps overall complexity low. It is conceptually aligned with Hexagonal Architecture, but more pragmatic and suitable for mobile development.

For state management this project uses **Cubit** (`flutter_bloc`). Cubit is considered a good practice for low/medium complexity UI state because it avoids excessive boilerplate while maintaining predictability, scalability and testability.

### Execution Flow

1. UI calls `cubit.shorten(url)`
2. Cubit triggers the UseCase
3. UseCase calls the Repository
4. Repository calls the Datasource (API)
5. API returns DTO
6. Repository converts DTO → Domain Entity
7. Cubit emits the new State
8. UI reacts and re-renders

### Layers

- **data** → API communication + DTO parsing + mapping to Entity  
- **domain** → pure entities + contracts + business rules (UseCases)  
- **presentation** → UI + Cubit + sealed states  
- **shared** → exceptions and constants reused across layers


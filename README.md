# URL Shortener – Flutter Take Home

Flutter mobile application to shorten URLs and display the list of recently generated short links.

## Objective

- Text input to type a URL
- Button to request URL shortening
- List displaying all returned aliases
- Session-based in-memory state (no local persistence)

# URL Shortener – Flutter Take Home

![CI Tests](https://github.com/anacsmartins/take-home/actions/workflows/flutter_test.yml/badge.svg?branch=main)
[![Coverage Status](https://coveralls.io/repos/github/anacsmartins/take-home/badge.svg?branch=main)](https://coveralls.io/github/anacsmartins/take-home?branch=main)
![license: MIT](https://img.shields.io/badge/license-MIT-green.svg)
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
├─ data/
│ ├─ datasources/
│ ├─ models/
│ └─ repositories/
│
├─ domain/
│ ├─ entities/
│ ├─ repositories/
│ └─ usecases/
│
├─ presentation/
│ ├─ cubit/
│ ├─ pages/
│ └─ widgets/
│
├─ shared/
│ ├─ constants.dart
│ └─ exceptions.dart
│
└─ injection/
├─ modules/
└─ injection.dart

test/
├─ data/
├─ domain/
└─ presentation/
``` 

---

## Como executar localmente

### Instalar dependências
```bash
flutter pub get
```
## Rodar o app (em emulador ou device)

### Running Tests
```bash
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

- **domain** é puro (sem dependência Flutter)
- **data** isola modelagem remota → API → DTO
- **presentation** apenas UI camada Cubit
- **injection** evita acoplamento e deixa testável
- **shared** contém apenas elementos globais com responsabilidade transversal



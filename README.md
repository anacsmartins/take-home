# URL Shortener – Flutter Take Home

Aplicação mobile Flutter para encurtar URLs e visualizar a lista recente de links encurtados.

## Objetivo

- Input para digitar URL
- Botão para encurtar
- Lista com aliases retornados
- Sessão em memória (não persiste localmente)

# URL Shortener – Flutter Take Home

[![tests](https://github.com/your_user/your_repo_name/actions/workflows/flutter_test.yml/badge.svg)](https://github.com/your_user/your_repo_name/actions/workflows/flutter_test.yml)
[![license: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
![Flutter](https://img.shields.io/badge/Flutter-Enterprise_Architecture-blue)

Mobile application built in Flutter to shorten URLs and display the recently generated short links during the session.  
Focused on code quality, separation of concerns and testability.

### API
`https://url-shortener-server.onrender.com/api/alias`

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

## Arquitetura do Projeto

Clean Architecture é a abordagem mais adotada em Flutter hoje, pois separa responsabilidades em camadas simples (domain / data / presentation) mantendo testabilidade, previsibilidade e baixa complexidade. É alinhada conceitualmente com hexagonal mas mais pragmática para mobile.

Cubit é considerado uma boa prática em Flutter quando usado para estado de UI de baixa/média complexidade, pois reduz boilerplate mantendo previsibilidade e testabilidade.

**Fluxograma**
- 1- UI → Cubit.addUrl(url)
- 2- Cubit chama usecase
- 3- usecase chama repository
- 4- repository chama API datasource
- 5- resultado volta
- 6- Cubit dá emit() com novo estado
- 7- UI re-render

- **data** → comunicação com API + transformação DTO
- **domain** → entidade e casos de uso (regras puras)
- **presentation** → UI + estado (Riverpod)
- **shared** → erros e utilidades comuns

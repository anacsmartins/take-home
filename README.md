# URL Shortener – Flutter Take Home

Aplicação mobile Flutter para encurtar URLs e visualizar a lista recente de links encurtados.

## Objetivo

- Input para digitar URL
- Botão para encurtar
- Lista com aliases retornados
- Sessão em memória (não persiste localmente)

API utilizada:  
`https://url-shortener-server.onrender.com/api/alias`

## Stacks

| Área | Tecnologia |
|------|------------|
| Mobile | Flutter (Dart null safety) |
| HTTP Client | http |
| State Management | Riverpod |
| Arquitetura | Clean Layers (data / domain / presentation) |
| Testes | Unit Test + Widget Test |
| Qualidade | Lints, separação de responsabilidades, zero code smell |

## Arquitetura do Projeto

Clean Architecture é a abordagem mais adotada em Flutter hoje, pois separa responsabilidades em camadas simples (domain / data / presentation) mantendo testabilidade, previsibilidade e baixa complexidade. É alinhada conceitualmente com hexagonal mas mais pragmática para mobile.

Cubit é considerado uma boa prática em Flutter quando usado para estado de UI de baixa/média complexidade, pois reduz boilerplate mantendo previsibilidade e testabilidade.

```bash
    lib/
    data/
      models/
      datasources/
      repositories/
    domain/
      entities/
      repositories/
      usecases/
    presentation/
      cubit/
      pages/
      widgets/
    shared/
``` 
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

## Executar o projeto

```bash
    flutter pub get
    flutter run

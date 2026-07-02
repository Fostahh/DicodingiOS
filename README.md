An iOS app for browsing video games — catalog, search, details, and favorites — powered by the [RAWG Video Games Database API](https://rawg.io/apidocs). Built with UIKit as the capstone submissions for Dicoding's iOS learning path.

**Each branch is a standalone capstone**: the same app rebuilt with a progressively more advanced architecture, from closure-based MVVM to a fully modularized Clean Architecture app split into Swift Packages with CI.

## Branches

| Branch | Course | Focus |
| --- | --- | --- |
| [`first-submission`](https://github.com/Fostahh/DicodingiOS/tree/first-submission) | Belajar Fundamental Aplikasi iOS | MVVM, `URLSession` networking |
| [`second-submission`](https://github.com/Fostahh/DicodingiOS/tree/second-submission) | Belajar Fundamental Aplikasi iOS | Adds Favorites, persisted with Core Data |
| [`MIDE-first-submission`](https://github.com/Fostahh/DicodingiOS/tree/MIDE-first-submission) | Menjadi iOS Developer Expert | Clean Architecture, Combine, Realm, dependency injection |
| [`MIDE-second-submission-SPM`](https://github.com/Fostahh/DicodingiOS/tree/MIDE-second-submission-SPM) | Menjadi iOS Developer Expert | Modularization into Swift Packages + own remote Core package, Codemagic CI |

## Features

- **Browse video games** — catalog list from RAWG
- **Search** — find games by title
- **Game details** — artwork, release date, rating, and description
- **Favorites** — save games locally (`second-submission` onward)
- **Profile page** — developer biodata
- **Localization** — English & Indonesian (`MIDE-second-submission-SPM`)

## `first-submission` — Fundamental, Submission 1

The baseline app: Home, Detail, and Profile screens over the RAWG API.

| Layer | Technology |
| --- | --- |
| Language | Swift |
| UI | UIKit (Storyboard + XIB views) |
| Architecture | MVVM (closure-based binding) |
| Networking | `URLSession` |
| Code Convention | SwiftLint |

## `second-submission` — Fundamental, Submission 2

Same architecture, plus a Favorite screen backed by local persistence.

| Layer | Technology |
| --- | --- |
| Architecture | MVVM (closure-based binding) |
| Networking | `URLSession` |
| Local storage | Core Data |
| Code Convention | SwiftLint |

## `MIDE-first-submission` — Expert, Submission 1

Rebuilt with **Clean Architecture**: remote and local data sources behind a repository, use-case interactors in the domain layer, and Combine publishers end to end.

```
View ──▶ ViewModel ──▶ Use Case (Interactor) ──▶ GameRepository
                                                      │
                                 RemoteDataSource ◀───┴───▶ LocalDataSource
                                (Alamofire, RAWG)             (Realm)
```

| Layer | Technology |
| --- | --- |
| Architecture | Clean Architecture (Data / Domain / Module) |
| Concurrency | Combine (`AnyPublisher` across all layers) |
| Networking | [Alamofire](https://github.com/Alamofire/Alamofire) |
| Local storage | [Realm](https://github.com/realm/realm-swift) |
| Dependency injection | Manual `Injection` container |
| Configuration | API key via `Info.plist` |

## `MIDE-second-submission-SPM` — Expert, Submission 2

The Clean Architecture app **modularized into Swift Packages** — one local package per feature plus a shared `Common` package, with the generic core abstractions extracted into [MIDE-Core](https://github.com/Fostahh/MIDE-Core), a separate versioned remote package. Built and tested on every push by Codemagic CI (see the [architecture diagram](https://github.com/Fostahh/DicodingiOS/blob/MIDE-second-submission-SPM/App%20Architecture.png)).

```
Submission Fundamental iOS/
├── App/                  # AppDelegate, SceneDelegate, MainFlowController
└── Module/               # local Swift Packages
    ├── Home/             # game list + search
    ├── DetailGame/       # game detail
    ├── Favorite/         # saved games
    ├── Biodata/          # profile page
    └── Common/           # shared UI, extensions, localized resources
```

| Layer | Technology |
| --- | --- |
| Modularity | Local Swift Packages per feature + [MIDE-Core](https://github.com/Fostahh/MIDE-Core) — own remote package |
| Architecture | Clean Architecture, flow-controller navigation |
| Concurrency | Combine |
| Networking | [Alamofire](https://github.com/Alamofire/Alamofire) |
| Local storage | [Realm](https://github.com/realm/realm-swift) |
| Localization | English & Indonesian (`Localizable.strings`) |
| CI | [Codemagic](https://codemagic.io) — build + tests per push |

## Requirements

- iOS 15.5+
- Xcode 15+
- A RAWG **API key**

## Acknowledgements

- Video game data provided by [RAWG](https://rawg.io/). This product uses the RAWG API but is not endorsed or certified by RAWG.

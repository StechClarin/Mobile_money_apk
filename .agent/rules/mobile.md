---
trigger: always_on
---

# My MoMo - Mobile Development Standards (Expert++ Level)

## 1. Architectural Mandate (Clean Architecture & DDD)
- **Feature-First Structure**: Every new feature must reside in `lib/features/{feature_name}/`.
- **Strict Layering**: 
    - `domain`: Pure Dart. Entities, UseCase interfaces, Repository interfaces. **Zero Flutter dependencies**.
    - `data`: Repository implementations, DataSources (Remote/Local), and Mappers (DTO to Entity).
    - `presentation`: UI components and State Management (Riverpod).
- **Dependency Inversion**: High-level modules must not depend on low-level modules. Both must depend on abstractions.

## 2. DRY & Reusability (The Obsession)
- **Atomic Design**: Never hardcode styles. Use the `lib/core/design_system/`.
- **Logic Extraction**: If a logic block is used twice, it belongs in a `UseCase` or a `Mixin`.
- **Generic Components**: UI widgets must be highly configurable (e.g., `MomoButton` should handle its own loading state and theme variants).

## 3. State Management & Reactivity (Riverpod)
- **Immutability**: All States must be `@immutable`. Use `copyWith` for state transitions.
- **Provider Scoping**: Use `AutoDispose` to prevent memory leaks in features like the QR Scanner.
- **Async Safety**: Use `AsyncValue` to handle loading/error/data states consistently.

## 4. Implementation Rules (Expert++ Level)
- **Error Handling**: Use the `Either<Failure, Success>` pattern (Dartz). No raw try/catch in the presentation layer.
- **Navigation**: All routes must be centralized in `lib/core/navigation/app_router.dart` (GoRouter). Use named routes and typed parameters.
- **QR & Camera**: Scanner logic must be decoupled from the UI. Create a `ScannerService` abstraction.
- **Performance**: 
    - Use `const` constructors everywhere possible.
    - Heavy operations (e.g., QR generation/parsing) must be offloaded to `Isolates` if they block the UI thread.

## 5. Coding Style
- **Naming**: Use intention-revealing names (e.g., `fetchUserBalanceUseCase` instead of `getData`).
- **Comments**: Code should be self-documenting. Comments are for "Why", not "What".
- **Safety**: No `dynamic` types. Enable strict-raw-types in `analysis_options.yaml`.
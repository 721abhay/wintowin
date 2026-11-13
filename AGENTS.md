# WinToWin — Coding Agent Discipline & Engineering Standards (AGENTS.md)

**Document Version:** 1.0  
**Enforcement Level:** Mandatory across all coding subagents and human contributors  
**Source of Truth Chain:** `PRD.md` -> `DESIGN.md` -> `ARCHITECTURE.md` -> `DATABASE.md` -> `API.md`

---

## 1. Golden Rules of Development

1. **Inspect Before Modifying**: Never edit, refactor, or delete existing code without first inspecting the target file and its callers. Understand existing conventions before making changes.
2. **Follow Project Documents**: `PRD.md`, `DESIGN.md`, `ARCHITECTURE.md`, `DATABASE.md`, and `API.md` are the single source of truth. Do not invent unapproved features, unauthorized database fields, or unnecessary dependencies.
3. **No Breaking Changes**: Avoid rewriting working code for subjective stylistic preferences. Ensure existing tests and features continue to function seamlessly.
4. **Never Expose Secrets**: Never commit, print, log, or hardcode API keys, Razorpay webhook secrets, database credentials, or auth tokens. Always read from environment variables or secure storage.
5. **Preserve Cross-Platform Parity**: WinToWin must run without native crashes on both **Apple iOS** and **Google Android**. Always verify platform permissions in `AndroidManifest.xml` and `Info.plist` when introducing plugins.

---

## 2. Code Quality & Naming Conventions

### 2.1 Dart & Flutter Conventions
- **Files & Folders**: `snake_case` (e.g., `brand_battle.dart`, `quiz_game_screen.dart`).
- **Classes, Enums, Mixins**: `PascalCase` (e.g., `WinToWinState`, `LeaderboardPlayer`, `RewardType`).
- **Variables, Functions, Getters**: `camelCase` (e.g., `calculateCombinedScore`, `playerPointsAwarded`).
- **Constants**: `lowerCamelCase` or `SCREAMING_SNAKE_CASE` for environment constants.
- **Private Members**: Prepend with an underscore `_` (e.g., `_playerScore`, `_startMatchmaking()`).

### 2.2 TypeScript / Backend Conventions
- Strict TypeScript (`strict: true` in `tsconfig.json`).
- Avoid `any`. Define explicit interfaces and DTOs matching `API.md` and `DATABASE.md`.

---

## 3. Architecture & Folder Boundaries

- **`lib/models/`**: Pure data classes. Keep serialization (`fromJson`/`toJson`) and immutability clean (`copyWith`).
- **`lib/services/`**: Reactive state management and asynchronous hardware/network communication. No UI code belongs in services.
- **`lib/screens/`**: High-level page views. Separate game arenas under `lib/screens/games/`.
- **`lib/widgets/`**: Reusable atomic UI components.
- **`lib/theme/`**: Centralized design tokens (colors, typography, radii, button styles). Never hardcode random hex colors inside leaf screen widgets.

---

## 4. State Management Discipline

- Use `ChangeNotifier` and `ListenableBuilder` or structured controllers.
- Avoid deep widget tree rebuilds: isolate volatile widgets (e.g., millisecond timers in `ReactionDuelScreen`) to their own stateful sub-trees.
- Maintain immutability for lists exposed through getters (e.g. `List.unmodifiable(_brands)`).

---

## 5. Security & Trust Boundaries

1. **Client is Untrusted**:
   - The Flutter mobile client only submits raw inputs and timestamps.
   - Point attribution and rank boosts must be calculated or verified server-side.
2. **Anti-Cheat Verification**:
   - Reaction times under $80\text{ ms}$ must be flagged as anomalous.
   - Respect the $1,000\text{ pts/day}$ player point cap at all times.
3. **External Store Isolation**:
   - Outbound shopping links must be opened securely via `url_launcher`.
   - Never inject payment forms or store credit cards within WinToWin.

---

## 6. Git & Change Discipline

- Keep commits small, atomic, and well-described using Conventional Commits:
  - `feat(game): add 1v1 brand trivia duel with speed bonus`
  - `fix(leaderboard): correct overtake amount calculation`
  - `docs(prd): update Phase 1 MVP scope`
- Run `flutter analyze` before committing. Zero errors and zero warnings are required for every build.
- Do not commit generated build caches (`build/`, `.dart_tool/`, `*.lock`).


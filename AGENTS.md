# AGENTS.md

## Project
This is an iOS app for collecting real-world plants, insects, birds, and small animals into a personal nature encyclopedia.

## Tech Stack
- Swift
- SwiftUI
- MVVM
- SwiftData for local persistence
- MapKit for map display
- CoreLocation for location
- Services should be protocol-based so mock services can be replaced later.

## Coding Rules
- Keep views small and composable.
- Put business logic in ViewModels or Services, not directly in Views.
- Use async/await for asynchronous calls.
- Avoid force unwraps.
- Add comments only where they clarify non-obvious logic.
- Do not hard-code API keys.
- Do not upload exact location unless user explicitly enables it.
- Do not claim species identification is 100% accurate.

## Safety Rules
- Every species identification result must include a safety disclaimer.
- Never show “edible” or “safe to touch” as a definitive recommendation.
- For mushrooms, snakes, insects, and unknown plants, show an extra caution message.
- Location should be blurred by default.

## Done Criteria
A task is complete only when:
- The app builds successfully.
- New functionality has basic preview or mock data.
- No sensitive permissions are requested without user-facing explanation.
- The code follows MVVM structure.

# AGENTS.md

## Project

This repository contains an iOS app named NatureDex, a SwiftUI app for collecting nature observations. Users can photograph or select images of plants, insects, birds, and small animals, identify candidates, and save confirmed results to a personal nature dex.

## Tech Stack

- Language: Swift
- UI: SwiftUI
- Architecture: MVVM
- Local persistence: SwiftData
- Maps: MapKit
- Minimum iOS version: iOS 17.0
- First implementation: local-first with mock services

## Important Product Rules

- All identification results are only suggestions.
- Every screen that displays identification results must show this safety copy:
  - `仅供参考，不可作为食用、采摘、接触依据`
- Users must manually confirm an identification candidate before it is added to the dex.
- Location data must be blurred by default.
- Do not store or display precise latitude/longitude for user observations.
- Do not block the core identification and dex flow when location permission is denied.
- Photo metadata should be sanitized before upload or future remote sync, especially GPS EXIF data.

## Current Files

- `PRD.md`: product requirements.
- `TECH_SPEC.md`: technical specification.
- `NatureDex.xcodeproj`: Xcode project.
- `NatureDex/`: Swift source files.

## Source Layout

- `NatureDex/NatureDexApp.swift`: app entry point.
- `NatureDex/ContentView.swift`: root tab view.
- `NatureDex/Models/`: plain Swift enums and constants.
- `NatureDex/SwiftDataModels/`: SwiftData entities.
- `NatureDex/Views/`: SwiftUI views.

## Development Guidelines

- Follow the architecture in `TECH_SPEC.md`.
- Keep SwiftUI views focused on rendering and user interaction.
- Put page state and orchestration in ViewModels.
- Put persistence behind repository protocols.
- Put identification, backend sync, image storage, location, and deletion logic behind service protocols.
- Use mock service implementations for MVP behavior.
- Keep future Supabase/Firebase support behind shared service protocols.
- Avoid adding production network dependencies until the mock MVP flow is working.

## Data Guidelines

- Do not store image binaries directly in SwiftData.
- Store local image file paths in SwiftData.
- Store only blurred coordinates in `ObservationEntity`.
- Keep raw `CLLocation` values in memory only long enough to compute blurred location.
- Deleting an observation should also delete associated local image files.

## UI Guidelines

- Use SwiftUI-native controls.
- Keep the first screen useful, not a marketing landing page.
- Prefer clear, compact screens suitable for repeated use.
- Use SF Symbols for icons.
- Keep cards at 8 pt corner radius or less unless the design system changes.
- Make empty states actionable.
- Do not add social, ranking, or sharing features in MVP unless explicitly requested.

## Testing Guidelines

Prioritize tests for:

- Location blurring.
- Identification result safety copy.
- Candidate confirmation before saving.
- SwiftData observation creation and deletion.
- Image file cleanup.
- Mock identification success and failure states.
- Map annotations using blurred coordinates only.

## Git Guidelines

- Keep commits focused.
- Do not rewrite history unless explicitly requested.
- Do not remove `PRD.md` or `TECH_SPEC.md`; they are project source documents.
- Avoid committing derived Xcode data or local user settings.


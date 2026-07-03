import SwiftData
import SwiftUI

@main
struct NatureDexApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            ObservationEntity.self,
            SpeciesEntity.self
        ])
    }
}


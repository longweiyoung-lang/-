import Foundation
import SwiftData

@MainActor
final class CollectionViewModel: ObservableObject {
    @Published var selectedCategory: SpeciesCategory?

    init(
        selectedCategory: SpeciesCategory? = nil
    ) {
        self.selectedCategory = selectedCategory
    }

    let filterCategories: [SpeciesCategory] = [
        .plant,
        .bird,
        .insect,
        .animal
    ]

    func filteredSightings(from sightings: [SightingEntity]) -> [SightingEntity] {
        guard let selectedCategory else {
            return sightings
        }

        return sightings.filter { $0.category == selectedCategory }
    }

    func delete(_ sighting: SightingEntity, modelContext: ModelContext) {
        modelContext.delete(sighting)
    }
}

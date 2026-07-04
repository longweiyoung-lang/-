import Foundation

@MainActor
final class CollectionViewModel: ObservableObject {
    @Published var observations: [MockObservation]
    @Published var selectedCategory: SpeciesCategory?

    init(
        observations: [MockObservation] = MockObservation.samples,
        selectedCategory: SpeciesCategory? = nil
    ) {
        self.observations = observations
        self.selectedCategory = selectedCategory
    }

    var filteredObservations: [MockObservation] {
        guard let selectedCategory else {
            return observations
        }

        return observations.filter { $0.category == selectedCategory }
    }
}


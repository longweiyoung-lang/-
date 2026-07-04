import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var displayName: String
    @Published var observationCount: Int
    @Published var badgeCount: Int
    @Published var locationMode: String

    init(
        displayName: String = "自然观察者",
        observationCount: Int = MockObservation.samples.count,
        badgeCount: Int = 2,
        locationMode: String = "默认模糊定位"
    ) {
        self.displayName = displayName
        self.observationCount = observationCount
        self.badgeCount = badgeCount
        self.locationMode = locationMode
    }
}


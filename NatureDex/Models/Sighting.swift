import Foundation

struct Sighting: Identifiable, Codable, Hashable {
    var id: String
    var speciesId: String
    var commonNameZh: String
    var scientificName: String
    var category: SpeciesCategory
    var photoURL: URL?
    var localImageName: String?
    var foundAt: Date
    var blurredLatitude: Double?
    var blurredLongitude: Double?
    var locationName: String?
    var confidence: Double
    var notes: String?
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        speciesId: String,
        commonNameZh: String,
        scientificName: String,
        category: SpeciesCategory,
        photoURL: URL? = nil,
        localImageName: String? = nil,
        foundAt: Date = .now,
        blurredLatitude: Double? = nil,
        blurredLongitude: Double? = nil,
        locationName: String? = nil,
        confidence: Double,
        notes: String? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.speciesId = speciesId
        self.commonNameZh = commonNameZh
        self.scientificName = scientificName
        self.category = category
        self.photoURL = photoURL
        self.localImageName = localImageName
        self.foundAt = foundAt
        self.blurredLatitude = blurredLatitude
        self.blurredLongitude = blurredLongitude
        self.locationName = locationName
        self.confidence = confidence
        self.notes = notes
        self.createdAt = createdAt
    }
}


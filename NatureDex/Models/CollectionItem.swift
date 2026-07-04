import Foundation

struct CollectionItem: Identifiable, Codable, Hashable {
    var id: String
    var sightingId: String
    var speciesId: String
    var commonNameZh: String
    var scientificName: String
    var category: SpeciesCategory
    var photoURL: URL?
    var localImageName: String?
    var foundAt: Date
    var blurredLatitude: Double?
    var blurredLongitude: Double?
    var confidence: Double
    var addedAt: Date
    var isFavorite: Bool

    init(
        id: String = UUID().uuidString,
        sightingId: String,
        speciesId: String,
        commonNameZh: String,
        scientificName: String,
        category: SpeciesCategory,
        photoURL: URL? = nil,
        localImageName: String? = nil,
        foundAt: Date = .now,
        blurredLatitude: Double? = nil,
        blurredLongitude: Double? = nil,
        confidence: Double,
        addedAt: Date = .now,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.sightingId = sightingId
        self.speciesId = speciesId
        self.commonNameZh = commonNameZh
        self.scientificName = scientificName
        self.category = category
        self.photoURL = photoURL
        self.localImageName = localImageName
        self.foundAt = foundAt
        self.blurredLatitude = blurredLatitude
        self.blurredLongitude = blurredLongitude
        self.confidence = confidence
        self.addedAt = addedAt
        self.isFavorite = isFavorite
    }
}


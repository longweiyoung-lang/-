import Foundation

struct Species: Identifiable, Codable, Hashable {
    var id: String
    var commonNameZh: String
    var scientificName: String
    var category: SpeciesCategory
    var photoURL: URL?
    var localImageName: String?
    var riskHint: String?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: String = UUID().uuidString,
        commonNameZh: String,
        scientificName: String,
        category: SpeciesCategory,
        photoURL: URL? = nil,
        localImageName: String? = nil,
        riskHint: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.commonNameZh = commonNameZh
        self.scientificName = scientificName
        self.category = category
        self.photoURL = photoURL
        self.localImageName = localImageName
        self.riskHint = riskHint
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}


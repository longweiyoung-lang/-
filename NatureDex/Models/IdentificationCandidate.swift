import Foundation

struct IdentificationCandidate: Identifiable, Codable, Hashable {
    var id: String
    var speciesId: String
    var commonNameZh: String
    var scientificName: String
    var category: SpeciesCategory
    var photoURL: URL?
    var localImageName: String?
    var confidence: Double
    var reason: String
    var safetyDisclaimer: String
    var extraCautionMessage: String?

    init(
        id: String = UUID().uuidString,
        speciesId: String,
        commonNameZh: String,
        scientificName: String,
        category: SpeciesCategory,
        photoURL: URL? = nil,
        localImageName: String? = nil,
        confidence: Double,
        reason: String,
        safetyDisclaimer: String = SafetyCopy.identificationNotice,
        extraCautionMessage: String? = nil
    ) {
        self.id = id
        self.speciesId = speciesId
        self.commonNameZh = commonNameZh
        self.scientificName = scientificName
        self.category = category
        self.photoURL = photoURL
        self.localImageName = localImageName
        self.confidence = confidence
        self.reason = reason
        self.safetyDisclaimer = safetyDisclaimer
        self.extraCautionMessage = extraCautionMessage
    }
}


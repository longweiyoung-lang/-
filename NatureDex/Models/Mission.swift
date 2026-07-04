import Foundation

enum MissionStatus: String, Codable, CaseIterable {
    case notStarted
    case inProgress
    case completed
}

struct Mission: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var detail: String
    var targetCount: Int
    var currentCount: Int
    var status: MissionStatus
    var category: SpeciesCategory?
    var rewardBadgeId: String?
    var activeDate: Date
    var completedAt: Date?

    init(
        id: String = UUID().uuidString,
        title: String,
        detail: String,
        targetCount: Int,
        currentCount: Int = 0,
        status: MissionStatus = .notStarted,
        category: SpeciesCategory? = nil,
        rewardBadgeId: String? = nil,
        activeDate: Date = .now,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.targetCount = targetCount
        self.currentCount = currentCount
        self.status = status
        self.category = category
        self.rewardBadgeId = rewardBadgeId
        self.activeDate = activeDate
        self.completedAt = completedAt
    }
}


import Foundation

enum NatureDexMockData {
    static let species: [Species] = [
        Species(
            id: "species-rosa-chinensis",
            commonNameZh: "月季",
            scientificName: "Rosa chinensis",
            category: .plant,
            photoURL: URL(string: "https://example.com/species/rosa-chinensis.jpg"),
            localImageName: "mock_rose",
            riskHint: "观赏植物，识别结果仅供参考。"
        ),
        Species(
            id: "species-coccinella-septempunctata",
            commonNameZh: "七星瓢虫",
            scientificName: "Coccinella septempunctata",
            category: .insect,
            photoURL: URL(string: "https://example.com/species/ladybug.jpg"),
            localImageName: "mock_ladybug",
            riskHint: "请勿捕捉或伤害昆虫。"
        ),
        Species(
            id: "species-pycnonotus-sinensis",
            commonNameZh: "白头鹎",
            scientificName: "Pycnonotus sinensis",
            category: .bird,
            photoURL: URL(string: "https://example.com/species/light-vented-bulbul.jpg"),
            localImageName: "mock_bulbul",
            riskHint: "请保持距离观察，不要惊扰鸟类。"
        )
    ]

    static let sightings: [Sighting] = [
        Sighting(
            id: "sighting-rose-001",
            speciesId: "species-rosa-chinensis",
            commonNameZh: "月季",
            scientificName: "Rosa chinensis",
            category: .plant,
            photoURL: URL(string: "https://example.com/sightings/rose-001.jpg"),
            localImageName: "mock_rose_sighting",
            foundAt: .now.addingTimeInterval(-3600),
            blurredLatitude: 31.2304,
            blurredLongitude: 121.4737,
            locationName: "上海市附近",
            confidence: 0.86,
            notes: "花坛附近发现。"
        ),
        Sighting(
            id: "sighting-ladybug-001",
            speciesId: "species-coccinella-septempunctata",
            commonNameZh: "七星瓢虫",
            scientificName: "Coccinella septempunctata",
            category: .insect,
            photoURL: URL(string: "https://example.com/sightings/ladybug-001.jpg"),
            localImageName: "mock_ladybug_sighting",
            foundAt: .now.addingTimeInterval(-86_400),
            blurredLatitude: 31.2240,
            blurredLongitude: 121.4810,
            locationName: "公园附近",
            confidence: 0.79,
            notes: "叶片背面停留。"
        ),
        Sighting(
            id: "sighting-bulbul-001",
            speciesId: "species-pycnonotus-sinensis",
            commonNameZh: "白头鹎",
            scientificName: "Pycnonotus sinensis",
            category: .bird,
            photoURL: URL(string: "https://example.com/sightings/bulbul-001.jpg"),
            localImageName: "mock_bulbul_sighting",
            foundAt: .now.addingTimeInterval(-172_800),
            blurredLatitude: 31.2380,
            blurredLongitude: 121.4620,
            locationName: "小区附近",
            confidence: 0.74,
            notes: "树枝上短暂停留。"
        )
    ]

    static let collectionItems: [CollectionItem] = sightings.map {
        CollectionItem(
            sightingId: $0.id,
            speciesId: $0.speciesId,
            commonNameZh: $0.commonNameZh,
            scientificName: $0.scientificName,
            category: $0.category,
            photoURL: $0.photoURL,
            localImageName: $0.localImageName,
            foundAt: $0.foundAt,
            blurredLatitude: $0.blurredLatitude,
            blurredLongitude: $0.blurredLongitude,
            confidence: $0.confidence,
            addedAt: $0.createdAt,
            isFavorite: $0.category == .bird
        )
    }

    static let missions: [Mission] = [
        Mission(
            id: "mission-identify-once",
            title: "今日完成 1 次识别",
            detail: "拍摄或选择一张自然照片并查看候选结果。",
            targetCount: 1,
            currentCount: 1,
            status: .completed,
            activeDate: .now,
            completedAt: .now.addingTimeInterval(-1800)
        ),
        Mission(
            id: "mission-add-one",
            title: "今日加入 1 个图鉴",
            detail: "确认一个识别候选并加入个人图鉴。",
            targetCount: 1,
            currentCount: 0,
            status: .inProgress,
            activeDate: .now
        )
    ]

    static let badges: [Badge] = [
        Badge(
            id: "badge-first-sighting",
            name: "初次发现",
            detail: "首次加入图鉴记录。",
            iconSystemName: "sparkle.magnifyingglass",
            requiredCount: 1,
            currentCount: 1,
            unlockedAt: .now.addingTimeInterval(-3600)
        ),
        Badge(
            id: "badge-plant-observer",
            name: "植物观察者",
            detail: "收集 5 个植物记录。",
            iconSystemName: "leaf",
            category: .plant,
            requiredCount: 5,
            currentCount: 1
        )
    ]

    static let identificationCandidates: [IdentificationCandidate] = [
        IdentificationCandidate(
            id: "candidate-rose",
            speciesId: "species-rosa-chinensis",
            commonNameZh: "月季",
            scientificName: "Rosa chinensis",
            category: .plant,
            photoURL: URL(string: "https://example.com/candidates/rose.jpg"),
            localImageName: "mock_rose_candidate",
            confidence: 0.86,
            reason: "花型、叶片边缘和枝条特征相似。",
            extraCautionMessage: "未知植物不可采摘或食用。"
        ),
        IdentificationCandidate(
            id: "candidate-ladybug",
            speciesId: "species-coccinella-septempunctata",
            commonNameZh: "七星瓢虫",
            scientificName: "Coccinella septempunctata",
            category: .insect,
            photoURL: URL(string: "https://example.com/candidates/ladybug.jpg"),
            localImageName: "mock_ladybug_candidate",
            confidence: 0.79,
            reason: "红色鞘翅与黑色斑点特征相似。",
            extraCautionMessage: "请勿捕捉、触摸或伤害昆虫。"
        ),
        IdentificationCandidate(
            id: "candidate-bulbul",
            speciesId: "species-pycnonotus-sinensis",
            commonNameZh: "白头鹎",
            scientificName: "Pycnonotus sinensis",
            category: .bird,
            photoURL: URL(string: "https://example.com/candidates/bulbul.jpg"),
            localImageName: "mock_bulbul_candidate",
            confidence: 0.72,
            reason: "头部白色羽冠和体型轮廓与常见白头鹎相似。",
            extraCautionMessage: "请保持距离观察，不要惊扰鸟类。"
        )
    ]
}

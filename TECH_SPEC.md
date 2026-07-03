# 自然收集图鉴 iOS App 技术规格

## 1. 技术选型

- 语言：Swift
- UI 框架：SwiftUI
- 架构：MVVM
- 本地数据：SwiftData
- 地图：MapKit
- 图片选择：PhotosUI
- 相机：UIKit `UIImagePickerController` 或自定义 `AVFoundation` 封装，MVP 建议先使用 `UIImagePickerController`
- 定位：CoreLocation
- 并发：Swift Concurrency，使用 `async/await`
- 后端：第一版使用 `MockService`，预留 Supabase/Firebase 实现
- 图片识别：第一版使用 `MockIdentificationService`，后续替换为真实识别 API

### 1.1 最低系统版本建议

建议 iOS 17.0+，原因：

- SwiftData 稳定可用。
- SwiftUI 与 MapKit 的声明式 API 更完整。
- PhotosUI 与现代权限模型集成更自然。

### 1.2 核心工程原则

- View 只负责展示和用户交互。
- ViewModel 负责页面状态、输入校验、调用 Service、错误转译。
- Service 负责业务能力抽象，所有外部能力都通过协议接入。
- Repository 负责 SwiftData 持久化读写。
- Mock 与真实实现必须共用同一协议，保证后续替换成本低。
- 所有定位信息在保存和展示前都必须模糊化。
- 所有识别结果页面必须显示固定安全提示：“仅供参考，不可作为食用、采摘、接触依据”。

## 2. 项目目录结构

```text
NatureDex/
  NatureDexApp.swift
  App/
    AppEnvironment.swift
    AppRoute.swift
    DependencyContainer.swift
  Models/
    SpeciesCategory.swift
    ObservationSource.swift
    TaskStatus.swift
    RecognitionStatus.swift
    LocationPrecision.swift
  SwiftDataModels/
    UserProfileEntity.swift
    ObservationEntity.swift
    SpeciesEntity.swift
    RecognitionRequestEntity.swift
    RecognitionCandidateEntity.swift
    DailyTaskEntity.swift
    UserTaskProgressEntity.swift
    BadgeEntity.swift
    UserBadgeEntity.swift
  DTO/
    IdentificationRequestDTO.swift
    IdentificationResponseDTO.swift
    IdentificationCandidateDTO.swift
    ObservationDTO.swift
    SyncResultDTO.swift
  Repositories/
    ObservationRepository.swift
    SwiftDataObservationRepository.swift
    TaskRepository.swift
    SwiftDataTaskRepository.swift
    BadgeRepository.swift
    SwiftDataBadgeRepository.swift
    UserSettingsRepository.swift
    SwiftDataUserSettingsRepository.swift
  Services/
    Identification/
      IdentificationService.swift
      MockIdentificationService.swift
      RemoteIdentificationService.swift
    Storage/
      ImageStorageService.swift
      LocalImageStorageService.swift
      RemoteImageStorageService.swift
    Location/
      LocationService.swift
      CoreLocationService.swift
      LocationObfuscationService.swift
    Backend/
      BackendService.swift
      MockBackendService.swift
      SupabaseBackendService.swift
      FirebaseBackendService.swift
    TaskEngine/
      TaskEngineService.swift
      DefaultTaskEngineService.swift
    BadgeEngine/
      BadgeEngineService.swift
      DefaultBadgeEngineService.swift
    Privacy/
      DataDeletionService.swift
      MetadataSanitizerService.swift
  ViewModels/
    HomeViewModel.swift
    CaptureViewModel.swift
    IdentificationResultViewModel.swift
    DexListViewModel.swift
    ObservationDetailViewModel.swift
    TasksViewModel.swift
    BadgesViewModel.swift
    MapFootprintViewModel.swift
    SettingsViewModel.swift
  Views/
    RootTabView.swift
    Home/
      HomeView.swift
      RecentObservationRow.swift
    Capture/
      CaptureEntryView.swift
      CameraPickerView.swift
      PhotoPickerView.swift
      ImagePreviewView.swift
    Identification/
      IdentificationLoadingView.swift
      IdentificationResultView.swift
      CandidateCardView.swift
      SafetyNoticeView.swift
    Dex/
      DexListView.swift
      DexCardView.swift
      ObservationDetailView.swift
      CategoryFilterView.swift
    Tasks/
      TasksView.swift
      TaskRowView.swift
    Badges/
      BadgesView.swift
      BadgeCellView.swift
    Map/
      MapFootprintView.swift
      ObservationMapAnnotationView.swift
    Settings/
      SettingsView.swift
      PrivacyPolicyView.swift
      SafetyGuideView.swift
      DataManagementView.swift
  Resources/
    Assets.xcassets
    Localizable.xcstrings
    MockData/
      mock_identification_candidates.json
      default_tasks.json
      default_badges.json
  Tests/
    NatureDexTests/
    NatureDexUITests/
```

## 3. 数据模型

### 3.1 通用枚举

```swift
enum SpeciesCategory: String, Codable, CaseIterable {
    case plant
    case insect
    case bird
    case animal
    case other
    case unknown
}

enum ObservationSource: String, Codable {
    case camera
    case photoLibrary
}

enum RecognitionStatus: String, Codable {
    case pending
    case succeeded
    case failed
}

enum TaskStatus: String, Codable {
    case notStarted
    case inProgress
    case completed
}

enum LocationPrecision: String, Codable {
    case blurred
    case cityOnly
    case hidden
}
```

### 3.2 SwiftData Entity

#### UserProfileEntity

```swift
@Model
final class UserProfileEntity {
    @Attribute(.unique) var id: String
    var nickname: String
    var avatarPath: String?
    var createdAt: Date
    var lastActiveAt: Date
    var locationEnabled: Bool
    var locationPrecisionRawValue: String
    var allowAnalytics: Bool
}
```

#### ObservationEntity

```swift
@Model
final class ObservationEntity {
    @Attribute(.unique) var id: String
    var speciesId: String
    var commonNameZh: String
    var scientificName: String
    var categoryRawValue: String
    var photoLocalPath: String
    var thumbnailLocalPath: String?
    var sourceRawValue: String
    var observedAt: Date
    var createdAt: Date

    var locationEnabled: Bool
    var locationDisplayName: String?
    var blurredLatitude: Double?
    var blurredLongitude: Double?
    var precisionMeters: Double?

    var recognitionRequestId: String?
    var confirmedCandidateId: String?
    var confidence: Double?
}
```

#### SpeciesEntity

```swift
@Model
final class SpeciesEntity {
    @Attribute(.unique) var id: String
    var commonNameZh: String
    var scientificName: String
    var categoryRawValue: String
    var descriptionShort: String?
    var riskHint: String?
    var createdAt: Date
    var updatedAt: Date
}
```

#### RecognitionRequestEntity

```swift
@Model
final class RecognitionRequestEntity {
    @Attribute(.unique) var id: String
    var imageLocalPath: String
    var statusRawValue: String
    var createdAt: Date
    var completedAt: Date?
    var errorCode: String?

    @Relationship(deleteRule: .cascade)
    var candidates: [RecognitionCandidateEntity]
}
```

#### RecognitionCandidateEntity

```swift
@Model
final class RecognitionCandidateEntity {
    @Attribute(.unique) var id: String
    var speciesId: String
    var commonNameZh: String
    var scientificName: String
    var categoryRawValue: String
    var confidence: Double
    var reason: String?
}
```

#### DailyTaskEntity

```swift
@Model
final class DailyTaskEntity {
    @Attribute(.unique) var id: String
    var title: String
    var detail: String
    var taskType: String
    var targetValue: Int
    var rewardType: String
    var rewardValue: Int
    var activeDate: Date
}
```

#### UserTaskProgressEntity

```swift
@Model
final class UserTaskProgressEntity {
    @Attribute(.unique) var id: String
    var taskId: String
    var currentValue: Int
    var targetValue: Int
    var statusRawValue: String
    var completedAt: Date?
}
```

#### BadgeEntity

```swift
@Model
final class BadgeEntity {
    @Attribute(.unique) var id: String
    var name: String
    var detail: String
    var iconName: String
    var conditionType: String
    var conditionValue: Int
}
```

#### UserBadgeEntity

```swift
@Model
final class UserBadgeEntity {
    @Attribute(.unique) var id: String
    var badgeId: String
    var isUnlocked: Bool
    var progressValue: Int
    var unlockedAt: Date?
}
```

### 3.3 图片存储

MVP 不建议把原图二进制直接放入 SwiftData。图片应保存到 App sandbox 的 Application Support 或 Documents 子目录，SwiftData 只保存本地路径。

要求：

- 保存前生成压缩后的展示图。
- 生成缩略图用于图鉴卡片。
- 上传真实 API 前移除 EXIF GPS 元数据。
- 删除图鉴记录时同步删除关联图片文件。

### 3.4 定位模糊化模型

定位原始坐标只允许在内存中短暂存在，用于计算模糊坐标。写入 SwiftData 或上传后端前必须转换为：

```swift
struct BlurredLocation: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let precisionMeters: Double
    let displayName: String?
}
```

MVP 模糊策略：

- 默认精度：1000 米。
- 可根据隐私策略调整到 500-2000 米。
- 坐标处理使用网格化或固定半径偏移，避免保存精确坐标。
- 无定位授权时，`locationEnabled = false`，地图页不展示该记录位置。

## 4. 页面列表

### 4.1 RootTabView

底部 Tab：

- 首页
- 图鉴
- 地图
- 任务
- 设置

### 4.2 首页 HomeView

功能：

- 拍照入口。
- 相册选择入口。
- 今日任务摘要。
- 最近 1-3 条图鉴记录。
- 安全提示入口。

ViewModel：`HomeViewModel`

### 4.3 图片采集 CaptureEntryView / ImagePreviewView

功能：

- 调用相机拍摄。
- 调用相册选择。
- 图片预览。
- 重新拍摄或重新选择。
- 确认后进入识别流程。

ViewModel：`CaptureViewModel`

### 4.4 识别中 IdentificationLoadingView

功能：

- 展示上传和识别进度。
- 失败时展示重试。
- 不展示虚假的精确进度，MVP 使用状态文案即可。

ViewModel：`IdentificationResultViewModel`

### 4.5 识别候选 IdentificationResultView

功能：

- 展示用户图片。
- 展示 1-3 个候选识别结果。
- 支持选择一个候选。
- 确认加入图鉴。
- 支持“暂不加入”。
- 必须展示安全提示：“仅供参考，不可作为食用、采摘、接触依据”。

ViewModel：`IdentificationResultViewModel`

### 4.6 图鉴列表 DexListView

功能：

- 展示图鉴卡片。
- 按类型筛选。
- 按发现时间倒序。
- 空状态引导拍摄或选择照片。

ViewModel：`DexListViewModel`

### 4.7 图鉴详情 ObservationDetailView

功能：

- 展示用户照片。
- 展示中文名、学名、类型、发现时间。
- 展示模糊位置。
- 展示来源：拍照或相册。
- 支持删除单条记录。

ViewModel：`ObservationDetailViewModel`

### 4.8 每日任务 TasksView

功能：

- 展示每日任务列表。
- 展示任务状态和进度。
- 任务完成后展示反馈。

ViewModel：`TasksViewModel`

### 4.9 徽章 BadgesView

功能：

- 展示徽章列表。
- 区分已获得和未获得。
- 展示徽章进度。

ViewModel：`BadgesViewModel`

### 4.10 地图足迹 MapFootprintView

功能：

- 使用 MapKit 展示模糊位置点。
- 点击位置点展示该区域发现记录。
- 无定位授权或无位置记录时展示空状态。
- 不展示精确经纬度。

ViewModel：`MapFootprintViewModel`

### 4.11 设置 SettingsView

功能：

- 隐私政策。
- 安全提示。
- 数据管理。
- 删除数据入口。
- 权限说明。
- 关于 App。

ViewModel：`SettingsViewModel`

## 5. Service 层设计

### 5.1 IdentificationService

职责：对图片进行物种识别，返回 1-3 个候选结果。

```swift
protocol IdentificationService {
    func identify(image: IdentificationImage) async throws -> IdentificationResponseDTO
}

struct IdentificationImage {
    let localURL: URL
    let mimeType: String
    let source: ObservationSource
}
```

#### MockIdentificationService

MVP 默认实现：

- 从本地 mock JSON 或内存数组返回候选结果。
- 模拟 0.8-1.5 秒延迟。
- 可配置失败率，用于测试错误状态。
- 返回候选数量必须为 1-3 个。

#### RemoteIdentificationService

后续真实 API 实现：

- 负责上传已清理 EXIF 的图片。
- 解析真实 API 响应为 `IdentificationResponseDTO`。
- API 失败时抛出领域错误。
- 不直接写 SwiftData。

### 5.2 ImageStorageService

职责：保存、压缩、缩略图生成、删除图片文件。

```swift
protocol ImageStorageService {
    func saveOriginalImage(_ data: Data, source: ObservationSource) async throws -> StoredImage
    func createThumbnail(from imageURL: URL) async throws -> URL
    func deleteImage(at url: URL) async throws
}

struct StoredImage {
    let originalURL: URL
    let thumbnailURL: URL?
}
```

### 5.3 MetadataSanitizerService

职责：移除图片 EXIF 中的敏感信息，尤其是 GPS 信息。

```swift
protocol MetadataSanitizerService {
    func sanitizedImageData(from data: Data) throws -> Data
}
```

要求：

- 真实上传前必须调用。
- 本地保存也建议保存清理后的图片。

### 5.4 LocationService

职责：获取用户授权和当前位置。

```swift
protocol LocationService {
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestWhenInUseAuthorization() async
    func currentLocation() async throws -> CLLocation?
}
```

要求：

- 定位失败不能阻断识别和加入图鉴。
- 未授权时创建无位置 Observation。

### 5.5 LocationObfuscationService

职责：将精确坐标转换为模糊坐标。

```swift
protocol LocationObfuscationService {
    func blur(_ location: CLLocation, precisionMeters: Double) -> BlurredLocation
}
```

要求：

- 所有写入 `ObservationEntity` 的坐标必须来自该 Service。
- 禁止将 `CLLocation.coordinate` 直接写入 SwiftData。

### 5.6 BackendService

职责：预留 Supabase/Firebase 同步接口。MVP 可使用 Mock。

```swift
protocol BackendService {
    func syncObservation(_ observation: ObservationDTO) async throws -> SyncResultDTO
    func deleteObservation(id: String) async throws
    func deleteAllUserData() async throws
    func uploadImage(localURL: URL) async throws -> URL
}
```

#### MockBackendService

MVP 默认实现：

- 不发起网络请求。
- 返回本地成功结果。
- 用于验证 ViewModel 和 Repository 流程。

#### SupabaseBackendService

后续实现方向：

- Supabase Auth 管理匿名或账号用户。
- Supabase Storage 存储图片。
- Postgres 表保存观察记录、任务进度、徽章。
- Row Level Security 限制用户只能访问自己的数据。

#### FirebaseBackendService

后续实现方向：

- Firebase Auth 管理匿名或账号用户。
- Cloud Storage 存储图片。
- Firestore 保存观察记录、任务进度、徽章。
- Security Rules 限制用户访问范围。

### 5.7 TaskEngineService

职责：根据用户行为更新每日任务。

```swift
protocol TaskEngineService {
    func handleRecognitionCompleted(at date: Date) async throws
    func handleObservationCreated(_ observation: ObservationEntity) async throws
    func refreshDailyTasks(for date: Date) async throws
}
```

### 5.8 BadgeEngineService

职责：根据图鉴数量、类型、连续天数等规则更新徽章。

```swift
protocol BadgeEngineService {
    func evaluateBadges(after event: BadgeEvent) async throws -> [UserBadgeEntity]
}

enum BadgeEvent {
    case observationCreated(ObservationEntity)
    case recognitionCompleted(Date)
    case appOpened(Date)
}
```

### 5.9 DataDeletionService

职责：删除本地和远端数据。

```swift
protocol DataDeletionService {
    func deleteObservation(_ observation: ObservationEntity) async throws
    func deleteAllLocalData() async throws
    func requestRemoteDataDeletion() async throws
}
```

要求：

- 删除图鉴记录时删除关联图片。
- 后续接入后端后，删除本地数据前或后需要调用 `BackendService` 删除远端记录。
- UI 必须二次确认。

## 6. ViewModel 层设计

### 6.1 HomeViewModel

状态：

- `recentObservations: [ObservationEntity]`
- `todayTaskSummaries: [TaskSummary]`
- `isLoading: Bool`
- `errorMessage: String?`

行为：

- `load()`
- `openCamera()`
- `openPhotoPicker()`
- `openSafetyGuide()`

### 6.2 CaptureViewModel

状态：

- `selectedImageData: Data?`
- `selectedSource: ObservationSource?`
- `previewImageURL: URL?`
- `isProcessingImage: Bool`
- `errorMessage: String?`

行为：

- `handleCameraImage(_ data: Data)`
- `handlePhotoLibraryImage(_ data: Data)`
- `confirmImage() async`
- `resetSelection()`

职责：

- 调用 `MetadataSanitizerService`。
- 调用 `ImageStorageService` 保存图片。
- 跳转到识别流程。

### 6.3 IdentificationResultViewModel

状态：

- `imageURL: URL`
- `candidates: [IdentificationCandidateDTO]`
- `selectedCandidateId: String?`
- `isIdentifying: Bool`
- `isSaving: Bool`
- `errorMessage: String?`
- `safetyNotice: String = "仅供参考，不可作为食用、采摘、接触依据"`

行为：

- `identify() async`
- `selectCandidate(id: String)`
- `confirmSelectedCandidate() async`
- `cancel()`
- `retry() async`

职责：

- 调用 `IdentificationService`。
- 创建 `RecognitionRequestEntity`。
- 用户确认后创建 `ObservationEntity`。
- 调用定位服务并只保存模糊位置。
- 更新任务和徽章。
- 所有候选展示状态下必须暴露 `safetyNotice` 给 View。

### 6.4 DexListViewModel

状态：

- `observations: [ObservationEntity]`
- `selectedCategory: SpeciesCategory?`
- `isLoading: Bool`
- `emptyStateMessage: String`

行为：

- `load()`
- `setCategoryFilter(_ category: SpeciesCategory?)`
- `deleteObservation(id: String) async`

### 6.5 ObservationDetailViewModel

状态：

- `observation: ObservationEntity`
- `isDeleting: Bool`
- `errorMessage: String?`

行为：

- `load(id: String)`
- `delete() async`

### 6.6 TasksViewModel

状态：

- `tasks: [TaskProgressViewData]`
- `isLoading: Bool`
- `completedTaskToast: String?`

行为：

- `loadTodayTasks() async`
- `refreshProgress() async`

### 6.7 BadgesViewModel

状态：

- `badges: [BadgeViewData]`
- `isLoading: Bool`

行为：

- `loadBadges() async`

### 6.8 MapFootprintViewModel

状态：

- `annotations: [FootprintAnnotation]`
- `selectedAnnotation: FootprintAnnotation?`
- `observationsInSelectedArea: [ObservationEntity]`
- `cameraPosition: MapCameraPosition`
- `locationPermissionState: LocationPermissionState`

行为：

- `loadAnnotations() async`
- `selectAnnotation(_ annotation: FootprintAnnotation)`
- `requestLocationPermission() async`

要求：

- 只读取 `blurredLatitude` 和 `blurredLongitude`。
- 不展示、不计算、不反推精确坐标。

### 6.9 SettingsViewModel

状态：

- `locationEnabled: Bool`
- `locationPrecision: LocationPrecision`
- `isDeletingData: Bool`
- `errorMessage: String?`

行为：

- `loadSettings()`
- `updateLocationEnabled(_ enabled: Bool)`
- `deleteAllData() async`
- `openSystemSettings()`

## 7. 后续接入真实 API 的接口设计

### 7.1 识别 API 抽象

客户端统一调用：

```swift
func identify(image: IdentificationImage) async throws -> IdentificationResponseDTO
```

请求 DTO：

```swift
struct IdentificationRequestDTO: Codable {
    let requestId: String
    let imageURL: URL?
    let categoryHint: SpeciesCategory?
    let locale: String
    let createdAt: Date
}
```

响应 DTO：

```swift
struct IdentificationResponseDTO: Codable {
    let requestId: String
    let status: RecognitionStatus
    let candidates: [IdentificationCandidateDTO]
    let completedAt: Date
}

struct IdentificationCandidateDTO: Codable, Identifiable {
    let id: String
    let speciesId: String
    let commonNameZh: String
    let scientificName: String
    let category: SpeciesCategory
    let confidence: Double
    let reason: String?
}
```

约束：

- `candidates.count` 必须为 1-3。
- 置信度仅作为参考展示，不得自动加入图鉴。
- 用户确认前不得创建最终 Observation。
- 识别失败需要返回可映射为用户文案的错误码。

### 7.2 后端同步 API 抽象

客户端统一调用 `BackendService`，不直接依赖 Supabase/Firebase SDK。

```swift
struct ObservationDTO: Codable {
    let id: String
    let speciesId: String
    let commonNameZh: String
    let scientificName: String
    let category: SpeciesCategory
    let photoRemoteURL: URL?
    let thumbnailRemoteURL: URL?
    let source: ObservationSource
    let observedAt: Date
    let createdAt: Date
    let location: BlurredLocation?
    let recognitionRequestId: String?
    let confirmedCandidateId: String?
    let confidence: Double?
}

struct SyncResultDTO: Codable {
    let remoteId: String
    let syncedAt: Date
}
```

### 7.3 REST API 建议

如果选择自建或通过 Edge Function 包装识别服务：

```http
POST /v1/identifications
Content-Type: multipart/form-data

image: binary
locale: zh-CN
categoryHint: optional string
```

```json
{
  "requestId": "rec_123",
  "status": "succeeded",
  "completedAt": "2026-07-04T10:00:00Z",
  "candidates": [
    {
      "id": "cand_1",
      "speciesId": "species_rose",
      "commonNameZh": "月季",
      "scientificName": "Rosa chinensis",
      "category": "plant",
      "confidence": 0.86,
      "reason": "花瓣形态和叶片边缘特征相似"
    }
  ]
}
```

```http
POST /v1/observations
DELETE /v1/observations/{id}
DELETE /v1/users/me/data
```

### 7.4 Supabase 数据表建议

- `profiles`
- `observations`
- `species`
- `recognition_requests`
- `recognition_candidates`
- `daily_tasks`
- `user_task_progress`
- `badges`
- `user_badges`

要求：

- 开启 Row Level Security。
- `user_id = auth.uid()` 作为访问条件。
- 图片存储桶按用户 ID 分目录。
- 不保存精确经纬度，只保存模糊坐标和精度。

### 7.5 Firebase 集合建议

- `users/{userId}`
- `users/{userId}/observations/{observationId}`
- `users/{userId}/recognitionRequests/{requestId}`
- `users/{userId}/taskProgress/{taskProgressId}`
- `users/{userId}/badges/{badgeId}`
- `publicSpecies/{speciesId}`
- `publicTasks/{taskId}`
- `publicBadges/{badgeId}`

要求：

- Security Rules 限制用户只能读写自己的记录。
- Cloud Storage 路径使用 `users/{userId}/observations/{imageId}`。
- 不上传 EXIF GPS 元数据。

## 8. 测试计划

### 8.1 单元测试

重点覆盖：

- `LocationObfuscationService`
  - 输入精确坐标后输出模糊坐标。
  - 输出精度符合 500-2000 米策略。
  - 不返回原始坐标。
- `MockIdentificationService`
  - 返回 1-3 个候选。
  - 支持成功、失败、空结果测试。
  - 候选字段完整。
- `IdentificationResultViewModel`
  - 识别成功后展示候选。
  - 未选择候选时不能确认加入。
  - 确认后创建 Observation。
  - 安全提示始终存在。
- `ImageStorageService`
  - 保存原图和缩略图。
  - 删除记录时清理图片文件。
- `MetadataSanitizerService`
  - 上传前移除 GPS EXIF。
- `TaskEngineService`
  - 完成识别后更新任务进度。
  - 创建图鉴后更新任务进度。
- `BadgeEngineService`
  - 首次发现发放徽章。
  - 分类数量达标后发放徽章。
- `DataDeletionService`
  - 删除单条 Observation。
  - 清空本地数据。
  - 删除图片文件。

### 8.2 ViewModel 测试

使用 Mock Repository 和 Mock Service，覆盖：

- 首页最近记录加载。
- 图鉴筛选和排序。
- 地图只加载有模糊坐标的记录。
- 设置页关闭定位后新记录不保存位置。
- 识别失败后的重试状态。

### 8.3 UI 测试

关键路径：

1. 首次打开 App，进入首页。
2. 从相册选择图片。
3. 图片预览确认。
4. Mock 识别返回候选。
5. 候选页显示安全提示：“仅供参考，不可作为食用、采摘、接触依据”。
6. 用户选择候选并加入图鉴。
7. 图鉴列表出现新卡片。
8. 图鉴详情展示中文名、学名、类型、发现时间、用户照片。
9. 地图页显示模糊位置点。
10. 设置页执行删除数据并回到空状态。

### 8.4 权限测试

相机：

- 首次授权。
- 用户拒绝授权。
- 拒绝后引导打开系统设置。

相册：

- 允许选择单张图片。
- 受限照片权限下仍能完成选择。

定位：

- 授权时保存模糊位置。
- 拒绝时仍可识别和加入图鉴。
- 关闭定位设置后不再保存位置。

### 8.5 隐私与安全测试

- 本地数据库不得保存精确经纬度。
- 上传图片前已移除 EXIF GPS。
- 图鉴、识别候选、设置安全页均可看到安全提示。
- 删除数据后 SwiftData 记录和本地图片文件都被清理。
- Mock 后端切换为真实后端时，删除接口被调用。

### 8.6 集成测试

覆盖服务组合：

- `CaptureViewModel -> MetadataSanitizerService -> ImageStorageService -> IdentificationService`
- `IdentificationResultViewModel -> ObservationRepository -> TaskEngineService -> BadgeEngineService`
- `ObservationDetailViewModel -> DataDeletionService -> ImageStorageService -> BackendService`
- `MapFootprintViewModel -> ObservationRepository -> MapKit Annotation`

### 8.7 回归测试清单

每次发布前验证：

- 识别候选数量为 1-3。
- 用户确认前不会加入图鉴。
- 安全提示在识别结果页必定展示。
- 定位默认模糊化。
- 无定位权限不影响核心流程。
- 删除单条记录会删除图片。
- 清空数据后首页、图鉴、地图、任务状态正常。
- MockService 与 RemoteService 可通过依赖注入切换。

## 9. 配置与依赖注入

### 9.1 AppEnvironment

```swift
enum AppEnvironment {
    case mock
    case development
    case production
}
```

### 9.2 DependencyContainer

```swift
@MainActor
final class DependencyContainer: ObservableObject {
    let identificationService: IdentificationService
    let backendService: BackendService
    let imageStorageService: ImageStorageService
    let locationService: LocationService
    let locationObfuscationService: LocationObfuscationService
    let taskEngineService: TaskEngineService
    let badgeEngineService: BadgeEngineService
    let dataDeletionService: DataDeletionService

    init(environment: AppEnvironment) {
        switch environment {
        case .mock:
            identificationService = MockIdentificationService()
            backendService = MockBackendService()
        case .development, .production:
            identificationService = RemoteIdentificationService()
            backendService = MockBackendService()
        }

        imageStorageService = LocalImageStorageService()
        locationService = CoreLocationService()
        locationObfuscationService = DefaultLocationObfuscationService()
        taskEngineService = DefaultTaskEngineService()
        badgeEngineService = DefaultBadgeEngineService()
        dataDeletionService = DefaultDataDeletionService()
    }
}
```

说明：

- MVP 使用 `.mock`。
- 接入 Supabase/Firebase 时只替换 `BackendService` 实现。
- 接入真实识别 API 时只替换 `IdentificationService` 实现。

## 10. 非功能要求

### 10.1 性能

- 图鉴列表使用缩略图，避免加载原图。
- 图片压缩和缩略图生成放在后台任务中执行。
- 识别请求必须可重试。
- SwiftData 查询按时间倒序并限制首页最近记录数量。

### 10.2 可用性

- 识别失败显示可理解的错误文案。
- 定位、相机、相册权限被拒绝时提供替代路径或设置引导。
- 空状态提供明确下一步操作。

### 10.3 隐私

- 默认不保存精确位置。
- 默认不公开任何用户照片。
- 上传前清理图片元数据。
- 设置页提供数据删除入口。

### 10.4 安全提示

以下文案应定义为常量并复用：

```swift
enum SafetyCopy {
    static let identificationNotice = "仅供参考，不可作为食用、采摘、接触依据"
}
```

使用位置：

- 识别候选页。
- 图鉴详情页的识别信息区域。
- 设置页安全提示。
- 任何未来展示识别结果的页面。

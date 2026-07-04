import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var recentObservations: [MockObservation]
    @Published var taskTitle: String
    @Published var completedTaskCount: Int
    @Published var totalTaskCount: Int

    init(
        recentObservations: [MockObservation] = Array(MockObservation.samples.prefix(3)),
        taskTitle: String = "今日完成 1 次自然识别",
        completedTaskCount: Int = 1,
        totalTaskCount: Int = 3
    ) {
        self.recentObservations = recentObservations
        self.taskTitle = taskTitle
        self.completedTaskCount = completedTaskCount
        self.totalTaskCount = totalTaskCount
    }
}


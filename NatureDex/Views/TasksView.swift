import SwiftUI

struct TasksView: View {
    var body: some View {
        NavigationStack {
            List {
                Label("今日完成 1 次识别", systemImage: "checkmark.circle")
                Label("今日加入 1 个图鉴", systemImage: "book")
                Label("本周收集 3 种不同类型", systemImage: "star")
            }
            .navigationTitle("任务")
        }
    }
}

#Preview {
    TasksView()
}


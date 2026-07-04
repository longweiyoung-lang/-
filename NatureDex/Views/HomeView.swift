import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    Image(systemName: "camera.macro")
                        .font(.system(size: 54))
                        .foregroundStyle(.green)
                    Text("自然收集图鉴")
                        .font(.title.bold())
                    Text("拍摄花草、昆虫、鸟类和小动物，加入你的个人自然图鉴。")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 24)

                VStack(alignment: .leading, spacing: 12) {
                    Label(viewModel.taskTitle, systemImage: "checkmark.circle")
                        .font(.headline)
                    ProgressView(value: Double(viewModel.completedTaskCount), total: Double(viewModel.totalTaskCount))
                    Text("\(viewModel.completedTaskCount)/\(viewModel.totalTaskCount) 个任务已完成")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 12) {
                    Text("最近发现")
                        .font(.headline)

                    ForEach(viewModel.recentObservations) { observation in
                        HStack(spacing: 12) {
                            Image(systemName: observation.imageSystemName)
                                .font(.title2)
                                .foregroundStyle(.green)
                                .frame(width: 36, height: 36)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(observation.commonNameZh)
                                    .font(.subheadline.bold())
                                Text(observation.scientificName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(observation.category.displayName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))

                SafetyNoticeView()
            }
            .padding()
            .navigationTitle("首页")
        }
    }
}

#Preview {
    HomeView()
}

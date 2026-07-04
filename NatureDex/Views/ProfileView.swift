import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.green)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.displayName)
                                .font(.headline)
                            Text(viewModel.locationMode)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }

                Section("收集概览") {
                    Label("\(viewModel.observationCount) 个图鉴记录", systemImage: "square.grid.2x2")
                    Label("\(viewModel.badgeCount) 枚徽章", systemImage: "rosette")
                }

                Section("隐私与安全") {
                    Label("定位默认模糊化", systemImage: "location.slash")
                    Label(SafetyCopy.identificationNotice, systemImage: "exclamationmark.triangle")
                }
            }
            .navigationTitle("我的")
        }
    }
}

#Preview {
    ProfileView()
}

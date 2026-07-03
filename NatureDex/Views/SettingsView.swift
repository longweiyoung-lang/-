import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("隐私与安全") {
                    NavigationLink("隐私政策") {
                        Text("隐私政策将在正式版本中提供。")
                            .padding()
                    }
                    NavigationLink("安全提示") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(SafetyCopy.identificationNotice)
                                .font(.headline)
                            Text("不要触摸、采摘、食用不明植物或菌类；不要靠近、捕捉或惊扰野生动物。")
                        }
                        .padding()
                    }
                }

                Section("数据") {
                    Button(role: .destructive) {
                    } label: {
                        Text("删除数据")
                    }
                }
            }
            .navigationTitle("设置")
        }
    }
}

#Preview {
    SettingsView()
}


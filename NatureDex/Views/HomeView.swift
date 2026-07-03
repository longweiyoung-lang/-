import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
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

                VStack(spacing: 12) {
                    Button {
                    } label: {
                        Label("拍照识别", systemImage: "camera")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                    } label: {
                        Label("从相册选择", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }

                SafetyNoticeView()

                Spacer()
            }
            .padding()
            .navigationTitle("首页")
        }
    }
}

#Preview {
    HomeView()
}


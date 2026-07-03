import SwiftUI

struct DexListView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "还没有图鉴记录",
                systemImage: "square.grid.2x2",
                description: Text("完成一次识别后，确认结果即可加入个人图鉴。")
            )
            .navigationTitle("图鉴")
        }
    }
}

#Preview {
    DexListView()
}


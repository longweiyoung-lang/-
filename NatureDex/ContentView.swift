import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house")
                }

            DexListView()
                .tabItem {
                    Label("图鉴", systemImage: "square.grid.2x2")
                }

            MapFootprintView()
                .tabItem {
                    Label("地图", systemImage: "map")
                }

            TasksView()
                .tabItem {
                    Label("任务", systemImage: "checklist")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
}


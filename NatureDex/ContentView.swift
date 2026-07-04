import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house")
                }

            CaptureView()
                .tabItem {
                    Label("拍照", systemImage: "camera")
                }

            CollectionView()
                .tabItem {
                    Label("图鉴", systemImage: "square.grid.2x2")
                }

            MapView()
                .tabItem {
                    Label("地图", systemImage: "map")
                }

            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            ObservationEntity.self,
            SightingEntity.self,
            SpeciesEntity.self
        ], inMemory: true)
}

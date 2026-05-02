import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            NavigationStack {
                TransportView()
            }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            NavigationStack {
                TripView()
            }
                .tabItem {
                    Label("Trips", systemImage: "ticket")
                }

            NavigationStack {
                ProfileView()
            }
                .tabItem {
                    Label("Hero", systemImage: "person")
                }
        }
        .tint(PixelPalette.blue)
    }
}

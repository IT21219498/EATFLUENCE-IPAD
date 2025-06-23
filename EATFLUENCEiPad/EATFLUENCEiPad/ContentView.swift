import SwiftUI

struct MainSplitView: View {
    var body: some View {
        NavigationSplitView {
            List {
                Section {
                    NavigationLink {
                        HomeView()
                    } label: {
                        Label("Home", systemImage: "house.fill")
                            .foregroundColor(.primaryColor)
                    }

                    NavigationLink {
                        RecipeListView()
                    } label: {
                        Label("Recipes", systemImage: "book.fill")
                            .foregroundColor(.primaryColor)
                    }

                    NavigationLink {
                        ProfileView()
                    } label: {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                            .foregroundColor(.primaryColor)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .background(Color.backgroundColor.opacity(0.1))
            .navigationTitle("🍽 EATFLUENCE")
        } detail: {
            WelcomeView()
        }
    }
}

#Preview {
    MainSplitView()
}

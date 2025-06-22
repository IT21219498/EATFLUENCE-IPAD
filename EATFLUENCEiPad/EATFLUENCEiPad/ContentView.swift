import SwiftUI

struct MainSplitView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink("Home", destination: HomeView())
                NavigationLink("Recipes", destination: RecipeListView())
                NavigationLink("Profile", destination: ProfileView())
            }
            .navigationTitle("EATFLUENCE")
        } detail: {
            Text("Select an option")
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    MainSplitView()
}

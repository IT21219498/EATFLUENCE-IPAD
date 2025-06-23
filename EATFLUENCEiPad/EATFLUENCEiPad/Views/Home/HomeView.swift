import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = PostViewModel()
    @State private var showAddPost = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 16)], spacing: 16) {
                    ForEach(viewModel.posts, id: \.self) { post in
                        FoodPostCardView(post: post)
                    }
                }
                .padding()
            }
            .background(Color.backgroundColor.opacity(0.05))
            .navigationTitle("🍽 Home Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddPost = true
                    }) {
                        Label("Add Post", systemImage: "plus")
                    }
                    .accessibilityIdentifier("addPostButton")
                    .keyboardShortcut("n", modifiers: [.command]) // CMD + N shortcut
                }
            }
            .onAppear {
                viewModel.fetchPosts()
            }
            .sheet(isPresented: $showAddPost, onDismiss: {
                viewModel.fetchPosts()
            }) {
                AddPostView()
            }
        }
    }
}

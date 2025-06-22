import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = PostViewModel()
    @State private var showAddPost = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.posts, id: \.self) { post in
                        FoodPostCardView(post: post)
                    }
                }
                .padding()
            }
            .navigationTitle("Home Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddPost = true
                    }) {
                        Label("Add Post", systemImage: "plus")
                    }
                    .accessibilityIdentifier("addPostButton")
                }
            }
            .onAppear {
                viewModel.fetchPosts()
            }
            .sheet(isPresented: $showAddPost, onDismiss: {
                viewModel.fetchPosts()  // Refresh after adding
            }) {
                AddPostView()
            }
        }
    }
}


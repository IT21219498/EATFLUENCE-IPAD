import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 12) {
                        Image(viewModel.userData.profileImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            .accessibilityLabel("Profile picture")

                        Text(viewModel.userData.username)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
                            .accessibilityIdentifier("profileUsername")
                    }

                    // Stats Row
                    HStack(spacing: 40) {
                        StatView(label: "Posts", value: viewModel.userData.postsCount)
                        StatView(label: "Saved", value: viewModel.userData.savedCount)
                        StatView(label: "Tried", value: viewModel.userData.triedCount)
                    }

                    Divider()

                    // My Posts
                    section(title: "My Posts", recipes: viewModel.postedRecipes, emptyMessage: "No posts yet")

                    Divider()

                    // Saved Recipes
                    section(title: "Saved Recipes", recipes: viewModel.savedRecipes, emptyMessage: "No saved recipes yet")

                    // Action Buttons
                    HStack(spacing: 20) {
                        Button("Edit Profile") {
                            viewModel.editProfile()
                        }
                        .buttonStyle(ProfileButtonStyle(color: .accentColor))

                        Button("Log Out") {
                            viewModel.logout()
                        }
                        .buttonStyle(ProfileButtonStyle(color: .red))
                        .accessibilityIdentifier("logoutButton")
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("Profile")
            .background(Color.backgroundColor.ignoresSafeArea())
            .onAppear {
                viewModel.fetchRecipes()
            }
        }
    }

    @ViewBuilder
    private func section(title: String, recipes: [RecipeEntity], emptyMessage: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.highlightColor)

            if recipes.isEmpty {
                Text(emptyMessage)
                    .font(.caption)
                    .foregroundColor(.secondaryTextColor)
                    .padding(.vertical, 4)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(recipes, id: \.self) { recipe in
                        RecipeSummaryCard(recipe: recipe)
                    }
                }
            }
        }
    }
}

// MARK: - Stat View
struct StatView: View {
    let label: String
    let value: Int

    var body: some View {
        VStack {
            Text("\(value)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primaryColor)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondaryTextColor)
        }
    }
}

// MARK: - Recipe Card
struct RecipeSummaryCard: View {
    let recipe: RecipeEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let data = recipe.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .clipped()
                    .cornerRadius(8)
            }

            Text(recipe.title ?? "Untitled")
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

// MARK: - Button Style
struct ProfileButtonStyle: ButtonStyle {
    var color: Color = .primaryColor

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

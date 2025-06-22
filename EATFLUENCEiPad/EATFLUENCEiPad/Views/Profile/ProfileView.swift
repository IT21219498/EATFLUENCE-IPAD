import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Profile Image & Username
                    VStack {
                        Image(viewModel.userData.profileImageName)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .accessibilityLabel("Profile picture")

                        Text(viewModel.userData.username)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .accessibilityIdentifier("profileUsername")
                    }

                    // Stats Row
                    HStack(spacing: 40) {
                        StatView(label: "Posts", value: viewModel.userData.postsCount)
                        StatView(label: "Saved", value: viewModel.userData.savedCount)
                        StatView(label: "Tried", value: viewModel.userData.triedCount)
                    }

                    Divider()

                    // Posted Recipes
                    SectionHeader(title: "My Posts")
                    if viewModel.postedRecipes.isEmpty {
                        Text("No posts yet")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.postedRecipes, id: \.self) { recipe in
                            RecipeSummaryCard(recipe: recipe)
                        }
                    }

                    Divider()

                    // Saved Recipes
                    SectionHeader(title: "Saved Recipes")
                    if viewModel.savedRecipes.isEmpty {
                        Text("No saved recipes yet")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.savedRecipes, id: \.self) { recipe in
                            RecipeSummaryCard(recipe: recipe)
                        }
                    }

                    // Action Buttons
                    HStack(spacing: 20) {
                        Button("Edit Profile") {
                            viewModel.editProfile()
                        }
                        .buttonStyle(ProfileButtonStyle())

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
            .onAppear {
                viewModel.fetchRecipes()
            }
        }
    }
}

// MARK: - Supporting Views
struct StatView: View {
    let label: String
    let value: Int

    var body: some View {
        VStack {
            Text("\(value)")
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

struct RecipeSummaryCard: View {
    let recipe: RecipeEntity

    var body: some View {
        HStack {
            if let data = recipe.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }

            Text(recipe.title ?? "Untitled")
                .font(.subheadline)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

struct ProfileButtonStyle: ButtonStyle {
    var color: Color = Color("PrimaryColor")

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

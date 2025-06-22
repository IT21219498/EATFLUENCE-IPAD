import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var showAddRecipe = false
    @State private var selectedRecipe: RecipeEntity?
    @State private var showEditRecipe = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.recipes, id: \.self) { recipe in
                    RecipeCardView(
                        recipe: recipe,
                        onDelete: {
                            viewModel.delete(recipe)
                        },
                        onTogglePrivacy: {
                            viewModel.togglePrivacy(for: recipe)
                        },
                        onEdit: {
                            selectedRecipe = recipe
                            showEditRecipe = true
                        }
                    )
                    .onTapGesture {
                        selectedRecipe = recipe
                    }
                }
            }
            .navigationTitle("My Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddRecipe = true
                    } label: {
                        Label("Add Recipe", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddRecipe) {
                AddRecipeView() // AddRecipeView creates its own VM or uses env context
            }
            .sheet(isPresented: $showEditRecipe) {
                if let recipe = selectedRecipe {
                    EditRecipeView(recipe: recipe)
                }
            }
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .onAppear {
                viewModel.fetchRecipes()
            }
        }
    }
}

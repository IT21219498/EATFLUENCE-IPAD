import SwiftUI

struct RecipeDetailView: View {
    let recipe: RecipeEntity
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let data = recipe.imageData, let img = UIImage(data: data) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                }

                Text(recipe.title ?? "Untitled Recipe")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryColor)
                    .padding(.horizontal)

                if let ingredients = recipe.ingredients {
                    sectionCard(title: "Ingredients", content: ingredients)
                }

                if let instructions = recipe.instructions {
                    sectionCard(title: "Instructions", content: instructions)
                }

                if let sketchData = recipe.sketchData, let sketchImg = UIImage(data: sketchData) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Sketch")
                            .font(.headline)
                            .foregroundColor(.accentColor)

                        Image(uiImage: sketchImg)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Recipe Detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Label("Back", systemImage: "chevron.left")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }

    @ViewBuilder
    private func sectionCard(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.accentColor)

            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}

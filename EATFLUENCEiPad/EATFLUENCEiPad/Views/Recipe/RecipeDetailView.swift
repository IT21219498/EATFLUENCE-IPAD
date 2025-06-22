import SwiftUI

struct RecipeDetailView: View {
    let recipe: RecipeEntity
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let data = recipe.imageData, let img = UIImage(data: data) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                Text(recipe.title ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                if let ingredients = recipe.ingredients {
                    Text("Ingredients")
                        .font(.headline)
                        .padding(.horizontal)
                    Text(ingredients)
                        .padding(.horizontal)
                }

                if let instructions = recipe.instructions {
                    Text("Instructions")
                        .font(.headline)
                        .padding(.horizontal)
                    Text(instructions)
                        .padding(.horizontal)
                }

                if let sketchData = recipe.sketchData, let sketchImg = UIImage(data: sketchData) {
                    Text("Your Sketch")
                        .font(.headline)
                        .padding(.horizontal)
                    Image(uiImage: sketchImg)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .navigationTitle("Recipe Detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
    }
}

import SwiftUI
import PencilKit

struct AddRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

    @State private var title: String = ""
    @State private var ingredients: String = ""
    @State private var instructions: String = ""
    @State private var isPublic: Bool = true
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var canvasView = PKCanvasView()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    imagePickerSection

                    textFieldSection

                    Toggle("Make Public", isOn: $isPublic)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    pencilKitSection

                    saveButton
                }
                .padding()
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }

    private var imagePickerSection: some View {
        Button {
            showImagePicker = true
        } label: {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(
                        Label("Tap to select image", systemImage: "photo.on.rectangle")
                            .foregroundColor(.accentColor)
                    )
            }
        }
    }

    private var textFieldSection: some View {
        VStack(spacing: 12) {
            TextField("Recipe Title", text: $title)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            TextField("Ingredients", text: $ingredients, axis: .vertical)
                .lineLimit(3...6)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            TextField("Instructions", text: $instructions, axis: .vertical)
                .lineLimit(4...10)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
    }

    private var pencilKitSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sketch Your Recipe")
                .font(.headline)
                .foregroundColor(.accentColor)

            DrawingCanvasView(canvasView: $canvasView)
                .frame(height: 200)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
        }
    }

    private var saveButton: some View {
        Button(action: saveRecipe) {
            Text("Save Recipe")
                .frame(maxWidth: .infinity)
                .padding()
                .background(title.isEmpty || selectedImage == nil || ingredients.isEmpty || instructions.isEmpty ? Color.gray : Color.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(title.isEmpty || selectedImage == nil || ingredients.isEmpty || instructions.isEmpty)
    }

    private func saveRecipe() {
        let newRecipe = RecipeEntity(context: context)
        newRecipe.id = UUID()
        newRecipe.title = title
        newRecipe.ingredients = ingredients
        newRecipe.instructions = instructions
        newRecipe.isPublic = isPublic
        newRecipe.userId = "user123"
        newRecipe.imageData = selectedImage?.jpegData(compressionQuality: 0.8)

        let renderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
        let sketchImage = renderer.image { _ in
            canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        }
        newRecipe.sketchData = sketchImage.jpegData(compressionQuality: 0.8)

        do {
            try context.save()
            dismiss()
        } catch {
            print("Failed to save recipe: \(error)")
        }
    }
}

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
                VStack(spacing: 16) {
                    // Image Picker
                    Button {
                        showImagePicker = true
                    } label: {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .overlay(
                                    Label("Tap to select image", systemImage: "photo.on.rectangle")
                                        .foregroundColor(.blue)
                                )
                        }
                    }

                    // Text Fields
                    Group {
                        TextField("Recipe Title", text: $title)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        TextField("Ingredients", text: $ingredients, axis: .vertical)
                            .lineLimit(3...6)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        TextField("Instructions", text: $instructions, axis: .vertical)
                            .lineLimit(4...10)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Toggle
                    Toggle("Make Public", isOn: $isPublic)
                        .padding(.horizontal)

                    // PencilKit Drawing
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sketch Your Recipe")
                            .font(.headline)
                        DrawingCanvasView(canvasView: $canvasView)
                            .frame(height: 200)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                    }

                    // Save Button
                    Button("Save Recipe") {
                        saveRecipe()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(10)
                    .disabled(title.isEmpty || selectedImage == nil || ingredients.isEmpty || instructions.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }

    private func saveRecipe() {
        let newRecipe = RecipeEntity(context: context)
        newRecipe.id = UUID()
        newRecipe.title = title
        newRecipe.ingredients = ingredients
        newRecipe.instructions = instructions
        newRecipe.isPublic = isPublic
        newRecipe.userId = "user123" // Replace with actual user session logic
        newRecipe.imageData = selectedImage?.jpegData(compressionQuality: 0.8)

        // Render PencilKit drawing to image
        let renderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
        let sketchImage = renderer.image { ctx in
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

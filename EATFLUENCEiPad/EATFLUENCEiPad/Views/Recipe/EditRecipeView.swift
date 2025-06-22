import SwiftUI

struct EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var recipe: RecipeEntity

    @State private var title: String = ""
    @State private var ingredients: String = ""
    @State private var instructions: String = ""
    @State private var isPublic: Bool = true
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false

    var body: some View {
        Form {
            Section("Title") {
                TextField("Title", text: $title)
            }

            Section("Ingredients") {
                TextField("Ingredients", text: $ingredients, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("Instructions") {
                TextField("Instructions", text: $instructions, axis: .vertical)
                    .lineLimit(4...10)
            }

            Section {
                Toggle("Make Public", isOn: $isPublic)
            }

            Section("Image") {
                Button {
                    showImagePicker = true
                } label: {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    } else if let data = recipe.imageData, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    } else {
                        Label("Select Image", systemImage: "photo.on.rectangle")
                            .foregroundColor(.blue)
                    }
                }
            }

            Section {
                Button("Save Changes") {
                    saveChanges()
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .navigationTitle("Edit Recipe")
        .onAppear {
            title = recipe.title ?? ""
            ingredients = recipe.ingredients ?? ""
            instructions = recipe.instructions ?? ""
            isPublic = recipe.isPublic
        }
    }

    private func saveChanges() {
        recipe.title = title
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        recipe.isPublic = isPublic

        if let selectedImage = selectedImage {
            recipe.imageData = selectedImage.jpegData(compressionQuality: 0.8)
        }

        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}

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
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                }

                Section(header: Text("Ingredients")) {
                    TextField("Ingredients", text: $ingredients, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section(header: Text("Instructions")) {
                    TextField("Instructions", text: $instructions, axis: .vertical)
                        .lineLimit(4...10)
                }

                Section {
                    Toggle("Make Public", isOn: $isPublic)
                }

                Section(header: Text("Image")) {
                    Button {
                        showImagePicker = true
                    } label: {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        } else if let data = recipe.imageData, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        } else {
                            Label("Select Image", systemImage: "photo.on.rectangle")
                                .foregroundColor(.accentColor)
                        }
                    }
                }

                Section {
                    Button("Save Changes", action: saveChanges)
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Edit Recipe")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .onAppear {
                title = recipe.title ?? ""
                ingredients = recipe.ingredients ?? ""
                instructions = recipe.instructions ?? ""
                isPublic = recipe.isPublic
            }
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

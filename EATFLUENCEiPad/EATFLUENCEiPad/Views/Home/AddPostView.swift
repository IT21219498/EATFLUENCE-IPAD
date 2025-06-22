import SwiftUI
import PencilKit

struct AddPostView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

    @State private var username: String = ""
    @State private var caption: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showSuccess = false
    @State private var canvasView = PKCanvasView()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("User")) {
                    TextField("Enter username", text: $username)
                }

                Section(header: Text("Caption")) {
                    TextField("Enter caption", text: $caption, axis: .vertical)
                        .lineLimit(2...5)
                }

                Section(header: Text("Select Image")) {
                    Button {
                        showImagePicker = true
                    } label: {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(8)
                        } else {
                            Label("Select Image", systemImage: "photo.on.rectangle")
                                .foregroundColor(.blue)
                        }
                    }
                }

                Section(header: Text("Sketch Your Meal")) {
                    DrawingCanvasView(canvasView: $canvasView)
                        .frame(height: 200)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                }

                Section {
                    Button("Save Post") {
                        savePost()
                    }
                    .disabled(username.isEmpty || caption.isEmpty || selectedImage == nil)
                }
            }
            .navigationTitle("New Post")
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
            .overlay(
                Group {
                    if showSuccess {
                        Label("Post Added!", systemImage: "checkmark.circle.fill")
                            .padding()
                            .background(Color.green.opacity(0.85))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .transition(.scale)
                    }
                }, alignment: .top
            )
        }
    }

    private func savePost() {
        let newPost = FoodPostEntity(context: context)
        newPost.id = UUID()
        newPost.username = username
        newPost.caption = caption
        newPost.timestamp = Date()
        newPost.imageData = selectedImage?.jpegData(compressionQuality: 0.8)

        // Save PencilKit sketch as image
        let renderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
        let sketchImage = renderer.image { ctx in
            canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        }
        newPost.sketchImageData = sketchImage.jpegData(compressionQuality: 0.8)

        do {
            try context.save()
            withAnimation {
                showSuccess = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        } catch {
            print("Failed to save post: \(error)")
        }
    }
}

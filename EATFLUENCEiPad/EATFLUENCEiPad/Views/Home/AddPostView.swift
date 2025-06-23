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

    @State private var isDropTargeted = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("👤 User").font(.headline)) {
                    TextField("Enter username", text: $username)
                        .textInputAutocapitalization(.none)
                        .disableAutocorrection(true)
                        .accessibilityIdentifier("Enter username")
                }

                Section(header: Text("📝 Caption").font(.headline)) {
                    TextField("Describe your meal", text: $caption, axis: .vertical)
                        .lineLimit(2...5)
                }

                Section(header: Text("📷 Photo").font(.headline)) {
                    VStack {
                        Button {
                            showImagePicker = true
                        } label: {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(12)
                                    .shadow(radius: 3)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.primaryColor, lineWidth: 2)
                                    )
                            } else {
                                VStack {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.system(size: 40))
                                        .foregroundColor(.accentColor)
                                    Text("Select or Drop Image")
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, minHeight: 150)
                                .background(isDropTargeted ? Color.accentColor.opacity(0.2) : Color(.secondarySystemBackground))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                            }
                        }
                        .onDrop(of: ["public.image"], isTargeted: $isDropTargeted) { providers in
                            handleDrop(providers: providers)
                        }
                    }
                }

                Section(header: Text("✏️ Sketch").font(.headline)) {
                    DrawingCanvasView(canvasView: $canvasView)
                        .frame(height: 200)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                }

                Section {
                    Button {
                        savePost()
                    } label: {
                        Label("Save Post", systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(username.isEmpty || caption.isEmpty || selectedImage == nil)
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier(("savePostButton"))
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

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        if let provider = providers.first(where: { $0.canLoadObject(ofClass: UIImage.self) }) {
            provider.loadObject(ofClass: UIImage.self) { object, _ in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.selectedImage = image
                    }
                }
            }
            return true
        }
        return false
    }

    private func savePost() {
        let newPost = FoodPostEntity(context: context)
        newPost.id = UUID()
        newPost.username = username
        newPost.caption = caption
        newPost.timestamp = Date()
        newPost.imageData = selectedImage?.jpegData(compressionQuality: 0.8)

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

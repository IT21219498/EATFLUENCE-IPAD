import SwiftUI

struct RecipeCardView: View {
    let recipe: RecipeEntity
    let onDelete: () -> Void
    let onTogglePrivacy: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack {
            if let data = recipe.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading) {
                Text(recipe.title ?? "Untitled")
                    .font(.headline)
                Text(recipe.isPublic ? "Public" : "Private")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Menu {
                Button(recipe.isPublic ? "Make Private" : "Make Public", action: onTogglePrivacy)
                Button("Edit", action: onEdit)
                Button("Delete", role: .destructive, action: onDelete)
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
            }
        }
    }
}

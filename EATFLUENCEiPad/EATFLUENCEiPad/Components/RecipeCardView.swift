import SwiftUI

struct RecipeCardView: View {
    let recipe: RecipeEntity
    let onDelete: () -> Void
    let onTogglePrivacy: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            if let data = recipe.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title ?? "Untitled")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(recipe.isPublic ? "Public" : "Private")
                    .font(.caption)
                    .foregroundColor(recipe.isPublic ? .accentColor : .gray)
            }

            Spacer()

            Menu {
                Button(recipe.isPublic ? "Make Private" : "Make Public", action: onTogglePrivacy)
                Button("Edit", action: onEdit)
                Button("Delete", role: .destructive, action: onDelete)
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
        .padding(.vertical, 4)
    }
}

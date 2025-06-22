import SwiftUI

struct FoodPostCardView: View {
    let post: FoodPostEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Profile + Username + Like
            HStack {
                Image("defaultProfile") // Ensure added to Assets.xcassets
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))

                Text(post.username ?? "Unknown User")
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Button(action: {
                    // TODO: Add like functionality
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.red.opacity(0.7))
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal)

            // Post Image
            if let data = post.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
            }

            // Caption
            if let caption = post.caption, !caption.isEmpty {
                Text(caption)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, 6)
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}


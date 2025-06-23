import SwiftUI

struct FoodPostCardView: View {
    let post: FoodPostEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // User info row
            HStack {
                Image("defaultProfile")  // Replace with actual user image if available
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .shadow(radius: 2)

                Text(post.username ?? "Unknown User")
                    .font(.headline)

                Spacer()

                Image(systemName: "heart.fill")
                    .foregroundColor(.accentColor)
            }

            // Post image
            if let data = post.imageData, let uiImage = UIImage(data: data) {
                ZStack(alignment: .bottomLeading) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(10)

                    // Optional gradient overlay for text readability
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.4), .clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .cornerRadius(10)
                }
            }

            // Caption
            Text(post.caption ?? "")
                .font(.body)
                .padding(.horizontal, 4)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

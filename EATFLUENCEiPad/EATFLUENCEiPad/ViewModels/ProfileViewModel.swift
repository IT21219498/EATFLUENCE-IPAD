import Foundation
import CoreData

class ProfileViewModel: ObservableObject {
    @Published var userData = UserDataModel(
        username: "spicy_dragon",
        postsCount: 12,
        savedCount: 5,
        triedCount: 3,
        profileImageName: "defaultProfile"
    )

    @Published var postedRecipes: [RecipeEntity] = []
    @Published var savedRecipes: [RecipeEntity] = []

    private let context = PersistenceController.shared.container.viewContext
    
    // Example hardcoded UUID (replace with your seeded user's UUID)
    private let currentUserId = UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!

    init() {
        seedUserIfNeeded()
        fetchUser()
        fetchRecipes()
    }

    /// Ensure there's a user in CoreData with the expected ID
    private func seedUserIfNeeded() {
        let request: NSFetchRequest<UserModel> = UserModel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", currentUserId as CVarArg)

        do {
            let existing = try context.fetch(request)
            if existing.isEmpty {
                let newUser = UserModel(context: context)
                newUser.id = currentUserId
                newUser.username = "spicy_dragon"
                newUser.postsCount = 12
                newUser.savedCount = 5
                newUser.triedCount = 3
                newUser.profileImageName = "defaultProfile"

                try context.save()
                print("Seeded default user.")
            }
        } catch {
            print("Failed to seed user: \(error)")
        }
    }

    /// Fetch user from CoreData
    func fetchUser() {
        let request: NSFetchRequest<UserModel> = UserModel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", currentUserId as CVarArg)

        do {
            if let coreDataUser = try context.fetch(request).first {
                userData = UserDataModel(
                    username: coreDataUser.username ?? "Unknown",
                    postsCount: Int(coreDataUser.postsCount),
                    savedCount: Int(coreDataUser.savedCount),
                    triedCount: Int(coreDataUser.triedCount),
                    profileImageName: coreDataUser.profileImageName ?? "defaultProfile"
                )
            } else {
                print("No user found. Using default data.")
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
    }

    /// Fetch user's own and saved recipes
    func fetchRecipes() {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let allRecipes = try context.fetch(request)
            postedRecipes = allRecipes.filter { $0.userId == currentUserId.uuidString }
            savedRecipes = allRecipes.filter { $0.isPublic && $0.userId != currentUserId.uuidString }
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }

    func editProfile() {
        print("Edit profile tapped")
    }

    func logout() {
        print("Logged out")
    }
}
